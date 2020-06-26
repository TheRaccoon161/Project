#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSystemTrayIcon>
#include <QApplication>
#include <QSettings>

#include <tray.h>
#include <qmltranslator.h>
#include <save.h>
#include <Mymodel.h>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    Tray * systemTray = new Tray();
    QQmlContext * context = engine.rootContext();
    QmlTranslator qmlTranslator;
    Save * saves= new Save();
    MyModel mymodel;

    qmlTranslator.setTranslation(saves->langugeLoad());;

    qmlRegisterType<MyModel>("model",1,0,"MyModel");

    context->setContextProperty("systemTray", systemTray);

    context->setContextProperty("Save",saves);

    context->setContextProperty("qmlTranslator", &qmlTranslator);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
