#include "Mymodel.h"

MyModel::MyModel(QObject *parent)
{
    m_struct.append(MyStruct{"url","name"});
}
QVariant MyModel::data(const QModelIndex &index, int role) const
{
    if(index.row() < 0 || index.row() > m_struct.size())
        return QVariant();

    switch (role) {
    case sourceSong:
        m_struct.at(index.row());
    case nameSong:
        m_struct.at(index.row());
    }
}

QHash<int, QByteArray> MyModel::roleName() const
{
    QHash<int, QByteArray> roleName;
    roleName[sourceSong] = "source";
    roleName[nameSong] = "name";
    return roleName;
}

void MyModel::append(QString source, QString name)
{
    m_struct.append(MyStruct{source,name});
}



int MyModel::rowCount(const QModelIndex &parent) const
{
    return m_struct.size();
}
