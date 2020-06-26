#ifndef MODEL_H
#define MODEL_H

#include <QQuickItem>
#include <QObject>
#include <QAbstractListModel>

struct MyStruct
{
    QString source;
    QString name;
};

class MyModel : public QAbstractListModel
{
    Q_OBJECT

    enum songInfo
    {
        sourceSong=Qt::DisplayRole,
        nameSong
    };

public:
    MyModel(QObject *parent = 0);

    QVariant data(const QModelIndex &index, int role=Qt::DisplayRole) const override;
    QHash<int,QByteArray> roleName() const;
    Q_INVOKABLE void append(QString source,QString name);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
private:
    QList<MyStruct> m_struct;

};

#endif // MODEL_H
