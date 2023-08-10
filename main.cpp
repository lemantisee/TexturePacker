#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "ImageProvider.h"
#include "Compressor.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    engine.addImageProvider(QLatin1String("base"), new ImageProvider);

    Compressor compresser;
    engine.rootContext()->setContextProperty("textureCompressor", &compresser);

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    const QUrl url(u"qrc:/TexturePacker/Main.qml"_qs);
    engine.load(url);

    return app.exec();
}
