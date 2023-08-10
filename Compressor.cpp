#include "Compressor.h"

#include <QDebug>
#include <QFileInfo>

#include "nvtt/nvtt.h"

Compressor::Compressor(QObject *parent)
    : QObject{parent}
{
    connect(&mWatcher, &QFutureWatcher<QString>::finished, this, &Compressor::onFinished);
}

void Compressor::startCompress(const QString &sourceFilepath, const QString &targetFilepath)
{
    qDebug() << "Source filepath " << sourceFilepath << " target filepath " << targetFilepath;

    auto future = QtConcurrent::run([sourceFilepath, targetFilepath] {
        nvtt::Surface image;
        if (!image.load(sourceFilepath.toStdString().c_str())) {
            qCritical("Unable to open %s file", qUtf8Printable(sourceFilepath));
            return QString("Unable to open image file");
        }

        nvtt::Context context(true);
        nvtt::CompressionOptions compressionOptions;
        compressionOptions.setFormat(nvtt::Format_BC7);

        nvtt::OutputOptions outputOptions;
        outputOptions.setFileName(targetFilepath.toStdString().c_str());

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