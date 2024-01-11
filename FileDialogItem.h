#pragma once

#include <QQuickItem>
#include <QFileDialog>
#include <QUrl>

class FileDialogItem : public QQuickItem
{
    Q_OBJECT

public:
    explicit FileDialogItem(QQuickItem *parent = nullptr);

    enum Type { SaveDialog, OpenDialog };
    Q_ENUM(Type)

    Q_PROPERTY(FileDialogItem::Type dialogType READ dialogType WRITE setDialogType NOTIFY typeChanged)
    Type dialogType() const;
    void setDialogType(Type type);

    Q_PROPERTY(QUrl fileUrl READ fileUrl NOTIFY fileUrlChanged)
    QUrl fileUrl() const;

    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    QString title() const;
    void setTitle(QString title);

    Q_PROPERTY(QStringList nameFilters READ nameFilters WRITE setNameFilters NOTIFY nameFiltersChanged)
    QStringList nameFilters() const;
    void setNameFilters(QStringList nameFilters);

    Q_INVOKABLE void open(QString filepath);

signals:
    void fileUrlChanged();
    void titleChanged();
    void nameFiltersChanged();
    void accepted();
    void rejected();
    void typeChanged();

private:
    void setFileUrl(QUrl fileUrl);

    QUrl mFileUrl;
    QString mTitle;
    QStringList mNameFilters;
    Type mType = OpenDialog;
};
