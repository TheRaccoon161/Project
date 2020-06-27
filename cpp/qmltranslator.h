#ifndef QMLTRANSLATOR_H
#define QMLTRANSLATOR_H

#include <QQuickItem>
#include <QObject>
#include <QTranslator>
#include <QSettings>


class QmlTranslator : public QObject
{
    Q_OBJECT

public:
    explicit QmlTranslator(QObject *parent = 0);

signals:
    void languageChanged();

public:
    Q_INVOKABLE void setTranslation(QString translation);

private:
    QTranslator m_translator;
};

#endif // QMLTRANSLATOR_H
