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

    // Сигналы от системного трея
signals:
    void signalIconActivated();
    void signalShow();
    void signalQuit();
    void signalNext();
    void signalPrevious();

private slots:
    /* Слот, который будет принимать сигнал от события
     * нажатия на иконку приложения в трее
     */
    void iconActivated(QSystemTrayIcon::ActivationReason reason);

public slots:
    void hideIconTray();
    void messege(QString title,QString messege);
    void setTranslation();

private:
    /* Объявляем объект будущей иконки приложения для трея */
    QSystemTrayIcon         * trayIcon;
    QMenu                   * trayIconMenu;
};

#endif // TRAY_H
