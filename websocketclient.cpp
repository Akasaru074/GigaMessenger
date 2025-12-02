#include "websocketclient.h"
#include <QJsonDocument>
#include <QJsonObject>
#include <QDateTime>
#include <QDebug>

WebSocketClient::WebSocketClient(QObject *parent)
    : QObject{parent}
{
    connect(&m_socket, &QWebSocket::connected, this, &WebSocketClient::onConnected);
    connect(&m_socket, &QWebSocket::disconnected, this, &WebSocketClient::onDisconnected);
    connect(&m_socket, &QWebSocket::textMessageReceived, this, &WebSocketClient::onTextMessageReceived);
    connect(&m_socket, QOverload<QAbstractSocket::SocketError>::of(&QWebSocket::error), this, &WebSocketClient::onSocketError);
}

void WebSocketClient::connectToServer(const QString &url, const QString &username) {
    m_username = username;
    m_socket.open(QUrl(url));
}

void WebSocketClient::disconnectFromServer() {
    m_socket.close();
}

void WebSocketClient::sendMessage(const QString &content, const QString &type) {
    QJsonObject msg;
    msg["sender"] = m_username;
    msg["type"] = type;
    msg["content"] = content;
    msg["timestamp"] = QDateTime::currentSecsSinceEpoch();

    QJsonDocument doc(msg);
    m_socket.sendTextMessage(doc.toJson(QJsonDocument::Compact));
}

void WebSocketClient::onConnected() {
    qDebug() << "WebSocket: connected";
    emit connected();
}

void WebSocketClient::onDisconnected() {
    qDebug() << "WebSocket: disconnected";
    emit disconnected();
}

void WebSocketClient::onTextMessageReceived(const QString &message) {
    qDebug() << "Received: " << message;

    QJsonParseError parseError;
    QJsonDocument doc = QJsonDocument::fromJson(message.toUtf8(), &parseError);

    if (parseError.error != QJsonParseError::NoError) {
        qDebug() << "JSON parse error: " << parseError.errorString();
        return;
    }

    if (!doc.isObject()) return;

    QJsonObject obj = doc.object();
    QString sender = obj["sender"].toString();
    QString type = obj["type"].toString();
    QString content = obj["content"].toString();
    QString timestamp = QDateTime::fromSecsSinceEpoch(obj["timestamp"].toInt()).toString("hh:mm");

    emit messageReceived(sender, content, type, timestamp);
}

void WebSocketClient::onSocketError(QAbstractSocket::SocketError error) {
    QString errStr = m_socket.errorString();
    qDebug() << "WebSocket error: " << errStr;
    emit errorOccurred(errStr);
}
