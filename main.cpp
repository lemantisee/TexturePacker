#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "ImageProvider.h"
#include "Compressor.h"
#include "FileDialogItem.h"
#include "ImageFilepath.h"
#include "Compressor.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    Compressor compresser;
    ImageFilepath imagePath;

    qmlRegisterType<FileDialogItem>("FileDialogItem", 1, 0, "FileDialogItem");
    qmlRegisterType<Compressor>("Compressor", 1, 0, "Compressor");

    QQmlApplicationEngine engine;

    engine.addImageProvider(QLatin1String("base"), new ImageProvider);
//    engine.rootContext()->setContextProperty("textureCompressor", &compresser);
    engine.rootContext()->setContextProperty("imageFilepath", &imagePath);

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    const QUrl url(u"qrc:/TexturePacker/Main.qml"_qs);
    engine.load(url);

    return app.exec();
}
