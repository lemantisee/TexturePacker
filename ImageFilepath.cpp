#include "ImageFilepath.h"

#include <QFileInfo>

ImageFilepath::ImageFilepath(QObject *parent)
    : QObject{parent}
{

}

QString ImageFilepath::getSaveFilename(const QString &filepath, const QString &extension) const
{
    QFileInfo file(filepath);
    return file.baseName() + "." + extension;
}

QString ImageFilepath::toFilePath(const QUrl &url) const
{
    return url.toLocalFile();
}
