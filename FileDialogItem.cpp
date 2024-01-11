#include "FileDialogItem.h"

#include <QApplication>

FileDialogItem::FileDialogItem(QQuickItem *parent)
    : QQuickItem(parent)
{
    /*
     * Qt Widgets support must be present, i.e. the main app is a QApplication.
     * The following line break at compile time, if the main app is a QGuiApplication
     */
    QApplication *appHasQtWidgetsSupport = qobject_cast<QApplication *>(
        QCoreApplication::instance());
    Q_ASSERT(appHasQtWidgetsSupport);
    Q_UNUSED(appHasQtWidgetsSupport);
}

FileDialogItem::Type FileDialogItem::dialogType() const
{
    return mType;
}

void FileDialogItem::setDialogType(Type type)
{
    mType = type;
}

QUrl FileDialogItem::fileUrl() const
{
    return mFileUrl;
}

void FileDialogItem::setFileUrl(QUrl fileUrl)
{
    if (mFileUrl != fileUrl) {
        mFileUrl = fileUrl;
        emit fileUrlChanged();
    }
}

QString FileDialogItem::title() const
{
    return mTitle;
}

void FileDialogItem::setTitle(QString title)
{
    if (mTitle != title) {
        mTitle = title;
        emit titleChanged();
    }
}

QStringList FileDialogItem::nameFilters() const
{
    return mNameFilters;
}

void FileDialogItem::setNameFilters(QStringList nameFilters)
{
    if (mNameFilters != nameFilters) {
        mNameFilters = nameFilters;
        emit nameFiltersChanged();
    }
}

void FileDialogItem::open(QString filepath)
{
    QString fileFilter;
    for (const QString &filter : mNameFilters) {
        fileFilter += filter;
        fileFilter += ";;";
    }
    if (!fileFilter.isEmpty()) {
        fileFilter.chop(2);
    }

    QUrl fileUrl;

    switch (mType) {
    case OpenDialog:
        fileUrl = QUrl::fromLocalFile(
            QFileDialog::getOpenFileName(nullptr, mTitle, filepath, fileFilter));
        break;
    case SaveDialog:
        fileUrl = QUrl::fromLocalFile(
            QFileDialog::getSaveFileName(nullptr, mTitle, filepath, fileFilter));
        break;
    default:
        break;
    }

    if (!fileUrl.isEmpty()) {
        setFileUrl(std::move(fileUrl));
        emit accepted();
        return;
    }

    emit rejected();
}
