#ifndef SAVE_H
#define SAVE_H


#include <QQuickItem>
#include <QSettings>

class Save : public QObject
{
    Q_OBJECT
public:
    explicit Save(QObject *parent = 0);

public slots:
    void languageSave(QString languge);
    QString langugeLoad();

private:
    QSettings    * saveLanguage;
    QSettings    * loadLanguage;

};

#endif // SAVE_H
