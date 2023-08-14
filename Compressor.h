#pragma once

#include <QObject>

#include <QtConcurrent/QtConcurrent>

class Compressor : public QObject
{
    Q_OBJECT
public:
    enum CompressionType { CompressionUnknwon, CompressionBC4, CompressionBC7 };
    Q_ENUM(CompressionType)

    explicit Compressor(QObject *parent = nullptr);

    Q_INVOKABLE void startCompress(const QString &sourceFilepath,
                                   const QString &targetFilepath,
                                   CompressionType compression);

signals:
    void started();
    void error(const QString &error);
    void finished();

private:
    void onFinished();

    QFutureWatcher<QString> mWatcher;
};

