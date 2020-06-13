#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSystemTrayIcon>
#include <QApplication>

#include <tray.h>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    Tray * systemTray = new Tray();
    QQmlContext * context = engine.rootContext();

    context->setContextProperty("systemTray", systemTray);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
