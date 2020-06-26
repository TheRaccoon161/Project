#include "save.h"

Save::Save(QObject *parent) : QObject(parent)
{

}

void Save::languageSave(QString languge)
{
    saveLanguage =new QSettings("settings.conf",QSettings::IniFormat);
    saveLanguage->setValue("Language/translations",languge);
    saveLanguage->sync();
}

QString Save::langugeLoad()
{
    loadLanguage = new QSettings("settings.conf",QSettings::IniFormat);
    return loadLanguage->value("Language/translations","en_US").toString();
}
