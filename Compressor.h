#pragma once

#include <QObject>

#include <QtConcurrent/QtConcurrent>

class Compressor : public QObject
{
    Q_OBJECT
public:
    explicit Compressor(QObject *parent = nullptr);

    Q_INVOKABLE void startCompress(const QString &sourceFilepath, const QString &targetFilepath);

signals:
    void error(const QString &error);
    void finished();

private:
    void onFinished();

    QFutureWatcher<QString> mWatcher;
};

