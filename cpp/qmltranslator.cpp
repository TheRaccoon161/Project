#include "qmltranslator.h"
#include <tray.h>
#include <QApplication>

QmlTranslator::QmlTranslator(QObject *parent) : QObject(parent)
{

}

void QmlTranslator::setTranslation(QString translation)
{
    m_translator.load(":/QmlLanguage_" + translation, ".");
    qApp->installTranslator(&m_translator);
    emit languageChanged();
}
