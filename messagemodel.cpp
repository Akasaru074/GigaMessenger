#include "messagemodel.h"
#include <QDateTime>

messageModel::messageModel(QObject* parent) : QAbstractListModel(parent) {
}

int messageModel::rowCount(const QModelIndex &parent) const {
    return m_messages.size();
}

QVariant messageModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() >= m_messages.size())
        return QVariant();

    const Message& msg = m_messages.at(index.row());

    switch (role) {
    case TypeRole:
        return QString::fromStdString(
            msg.type == Message::Text ? "text" :
            msg.type == Message::Image ? "image" : "emoji"
        );
    case ContentRole:
        return msg.content;
    case IsOwnRole:
        return msg.isOwn;
    case TimestampRole:
        return msg.timestamp.toString("hh::mm");
    default:
        return QVariant();
    }

}

QHash<int, QByteArray> messageModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[TypeRole] = "type";
    roles[ContentRole] = "content";
    roles[IsOwnRole] = "isOwn";
    roles[TimestampRole] = "timestamp";
    return roles;
}

Message::Type messageModel::stringToType(const QString &typeStr) {
    if (typeStr == "image") return Message::Image;
    if (typeStr == "emoji") return Message::Emoji;
    return Message::Text;
}

void messageModel::addMessage(const QString &content, bool isOwn, const QString &typeStr) {
    beginInsertRows(QModelIndex(), m_messages.size(), m_messages.size());

    Message msg;
    msg.type = stringToType(typeStr);
    msg.content = content;
    msg.isOwn = isOwn;
    msg.timestamp = QDateTime::currentDateTime();

    m_messages.append(msg);

    endInsertRows();
}
