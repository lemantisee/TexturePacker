#pragma once

#include <QObject>
#include <QUrl>

class ImageFilepath : public QObject
{
    Q_OBJECT
public:
    explicit ImageFilepath(QObject *parent = nullptr);
    Q_INVOKABLE QString getSaveFilename(const QString &filepath, const QString &extension) const;
    Q_INVOKABLE QString toFilePath(const QUrl &url) const;
};

