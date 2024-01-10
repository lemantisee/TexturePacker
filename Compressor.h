#pragma once

#include <QObject>

#include <QtConcurrent/QtConcurrent>

#include "nvtt/nvtt.h"

class Compressor : public QObject
{
    Q_OBJECT
public:
    enum CompressionType { CompressionUnknwon, CompressionBC4, CompressionBC7 };
    Q_ENUM(CompressionType)

    enum MipmapType { MipmapNone, MipmapBox, MipmapTriangle, MipmapKaiser };
    Q_ENUM(MipmapType)

    explicit Compressor(QObject *parent = nullptr);

    Q_INVOKABLE void startCompress(const QString &sourceFilepath,
                                   const QString &targetFilepath,
                                   CompressionType compression,
                                   MipmapType mipmapType);

signals:
    void started();
    void error(const QString &error);
    void finished();

private:
    void onFinished();
    nvtt::MipmapFilter getFilter(MipmapType mipmapType) const;
    QString compressWithMipmaps(nvtt::Context &context,
                                nvtt::Surface &image,
                                const nvtt::CompressionOptions &compressionOptions,
                                const nvtt::OutputOptions &outputOptions,
                                MipmapType mipmapType);

    QFutureWatcher<QString> mWatcher;
};

