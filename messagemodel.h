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

class messageModel : public QAbstractListModel
{
    Q_OBJECT
public:

    enum Roles {
        TypeRole = Qt::UserRole + 1,
        ContentRole,
        IsOwnRole,
        TimestampRole
    };

    explicit messageModel(QObject* parent = nullptr);

    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;

    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void addMessage(const QString& content, bool isOwn, const QString& typeStr = "text");
    Q_INVOKABLE void addMessageEx(const QString& sender, const QString& content, bool isOwn, const QString& type, const QString& timestamp);

private:
    QList<Message> m_messages;
    static Message::Type stringToType (const QString& typeStr);

};

#endif // MESSAGEMODEL_H
