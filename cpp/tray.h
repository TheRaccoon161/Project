#ifndef TRAY_H
#define TRAY_H

#include <QQuickItem>
#include <QObject>
#include <QAction>
#include <QSystemTrayIcon>
#include <QApplication>

class Tray : public QObject
{
    Q_OBJECT
public:
    explicit Tray(QObject *parent = 0);

signals:
    void signalIconActivated();
    void signalShow();
    void signalQuit();
    void signalNext();
    void signalPrevious();

private slots:
    void iconActivated(QSystemTrayIcon::ActivationReason reason);

public slots:
    void hideIconTray();
    void messege(QString title,QString messege);
    void setTranslation();

private:
    QSystemTrayIcon         * trayIcon;
    QMenu                   * trayIconMenu;
};

#endif // TRAY_H
