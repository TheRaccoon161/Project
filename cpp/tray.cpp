#include "tray.h"
#include <QMenu>
#include <QSystemTrayIcon>
#include <QTranslator>
#include <qmltranslator.h>


Tray::Tray(QObject *parent) : QObject(parent)
{

    trayIconMenu = new QMenu();

    trayIcon = new QSystemTrayIcon();
    setTranslation();
    trayIcon->setIcon(QIcon(":/play-button.png"));
    trayIcon->show();
    trayIcon->setToolTip("MediaPlayer");

    connect(trayIcon, SIGNAL(activated(QSystemTrayIcon::ActivationReason)),
            this, SLOT(iconActivated(QSystemTrayIcon::ActivationReason)));
}

void Tray::iconActivated(QSystemTrayIcon::ActivationReason reason)
{
    switch (reason){
    case QSystemTrayIcon::Trigger:
        emit signalIconActivated();
        break;
    default:
        break;
    }
}

void Tray::hideIconTray()
{
    trayIcon->hide();
}
void Tray::messege(QString title,QString messege){
    trayIcon->showMessage(title,messege,QSystemTrayIcon::Information,500);
}
void Tray::setTranslation(){
    trayIconMenu->clear();

    QAction * viewWindow = new QAction(trUtf8("Open"), this);
    QAction * quitAction = new QAction(trUtf8("Exit"), this);
    QAction * nextSong = new QAction(trUtf8("Next"),this);
    QAction * previousSong = new QAction(trUtf8("Priviouse"),this);

    connect(viewWindow, &QAction::triggered, this, &Tray::signalShow);
    connect(quitAction, &QAction::triggered, this, &Tray::signalQuit);
    connect(nextSong, &QAction::triggered,this, &Tray::signalNext);
    connect(previousSong, &QAction::triggered,this, &Tray::signalPrevious);

    trayIconMenu->addAction(viewWindow);
    trayIconMenu->addAction(nextSong);
    trayIconMenu->addAction(previousSong);
    trayIconMenu->addAction(quitAction);
    trayIcon->setContextMenu(trayIconMenu);
}
