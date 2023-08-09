#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "ImageProvider.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.addImageProvider(QLatin1String("base"), new ImageProvider);
    const QUrl url(u"qrc:/TexturePacker/Main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
