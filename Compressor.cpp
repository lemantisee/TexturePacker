#include "Compressor.h"

#include <QDebug>
#include <QFileInfo>

#include "nvtt/nvtt.h"

Compressor::Compressor(QObject *parent)
    : QObject{parent}
{
    connect(&mWatcher, &QFutureWatcher<QString>::finished, this, &Compressor::onFinished);
}

void Compressor::startCompress(const QString &sourceFilepath,
                               const QString &targetFilepath,
                               CompressionType compression)
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

    qDebug() << "Source filepath " << sourceFilepath << " target filepath " << targetFilepath;

    auto future = QtConcurrent::run([sourceFilepath, targetFilepath, compression] {
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

        if (!context.outputHeader(image, 1, compressionOptions, outputOptions)) {
            qCritical("Writing the DDS header failed");
            return QString("Writing the DDS header failed");
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
