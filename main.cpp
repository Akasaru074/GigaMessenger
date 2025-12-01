#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "messagemodel.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<messageModel>("Messenger.Models", 1, 0, "MessageModel");

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("GigaMessenger", "Main");

    return app.exec();
}
