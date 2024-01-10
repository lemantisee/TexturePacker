#include "Compressor.h"

#include <QDebug>
#include <QFileInfo>

Compressor::Compressor(QObject *parent)
    : QObject{parent}
{
    connect(&mWatcher, &QFutureWatcher<QString>::finished, this, &Compressor::onFinished);
}

void Compressor::startCompress(const QString &sourceFilepath,
                               const QString &targetFilepath,
                               CompressionType compression,
                               MipmapType mipmapType)
{
    if (sourceFilepath.isEmpty()) {
        qCritical("Empty image file path");
        return;
    }

    if (targetFilepath.isEmpty()) {
        qCritical("Empty target filepath");
        return;
    }

    if (!QFileInfo::exists(sourceFilepath)) {
        qCritical("Unable to find %s file", qUtf8Printable(sourceFilepath));
        return;
    }

    auto future = QtConcurrent::run([this, sourceFilepath, targetFilepath, compression, mipmapType] {
        nvtt::Surface image;
        if (!image.load(sourceFilepath.toStdString().c_str())) {
            qCritical("Unable to open %s file", qUtf8Printable(sourceFilepath));
            return QString("Unable to open image file");
        }

        nvtt::Context context(true);
        nvtt::CompressionOptions compressionOptions;

        switch (compression) {
        case CompressionBC4:
            compressionOptions.setFormat(nvtt::Format_BC4);
            break;
        case CompressionBC7:
            compressionOptions.setFormat(nvtt::Format_BC7);
            break;
        default:
            qCritical("Unknown compression format %i", compression);
            return QString("Unknown compression format");
        }

        nvtt::OutputOptions outputOptions;
        outputOptions.setFileName(targetFilepath.toStdString().c_str());
        outputOptions.setContainer(nvtt::Container_DDS10);

        int numMipmaps = 1;
        if (mipmapType != MipmapNone) {
            numMipmaps = image.countMipmaps();
        }

        if (!context.outputHeader(image, numMipmaps, compressionOptions, outputOptions)) {
            qCritical("Writing the DDS header failed");
            return QString("Writing the DDS header failed");
        }

        if (mipmapType != MipmapNone) {
            return compressWithMipmaps(context, image, compressionOptions, outputOptions, mipmapType);
        }

        if (!context.compress(image, 0, 0, compressionOptions, outputOptions)) {
            qCritical("Compressing and writing the DDS file failed");
            return QString("Compressing and writing the DDS file failed");
        }

        return QString();
    });

    mWatcher.setFuture(future);

    emit started();
}

void Compressor::onFinished()
{
    QString res = mWatcher.result();
    if (res.isEmpty()) {
        emit finished();
        return;
    }

    emit error(res);
}

nvtt::MipmapFilter Compressor::getFilter(MipmapType mipmapType) const
{
    switch (mipmapType) {
    case MipmapBox:
        return nvtt::MipmapFilter_Box;
    case MipmapTriangle:
        return nvtt::MipmapFilter_Triangle;
    case MipmapKaiser:
        return nvtt::MipmapFilter_Kaiser;
    default:
        qCritical("Unknown mipmap filter type");
        break;
    }

    return nvtt::MipmapFilter_Box;
}

QString Compressor::compressWithMipmaps(nvtt::Context &context,
                                        nvtt::Surface &image,
                                        const nvtt::CompressionOptions &compressionOptions,
                                        const nvtt::OutputOptions &outputOptions,
                                        MipmapType mipmapType)
{
    const int numMipmaps = image.countMipmaps();

    for (int mip = 0; mip < numMipmaps; mip++) {

        if (!context.compress(image, 0, mip, compressionOptions, outputOptions)) {
            qCritical("Compressing and writing the DDS file failed");
            return QString("Compressing and writing the DDS file failed");
        }

        if (mip == numMipmaps - 1) {
            break;
        }

        image.buildNextMipmap(getFilter(mipmapType));
    }

    return {};
}
