#ifndef MESSAGEMODEL_H
#define MESSAGEMODEL_H

#include <QAbstractListModel>
#include <QDateTime>
#include <QVariantMap>

struct Message {
    enum Type {
        Text,
        Image,
        Emoji
    };

    Type type;
    QString content;
    bool isOwn;
    QDateTime timestamp;
};

class messageModel
{
public:
    messageModel();
};

#endif // MESSAGEMODEL_H
