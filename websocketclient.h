#ifndef WEBSOCKETCLIENT_H
#define WEBSOCKETCLIENT_H

#include <QObject>
#include <QWebSocket>
#include <QUrl>

class WebSocketClient : public QObject
{
    Q_OBJECT
public:
    explicit WebSocketClient(QObject *parent = nullptr);
    Q_INVOKABLE void connectToServer(const QString& url, const QString& username);
    Q_INVOKABLE void disconnectFromServer();
    Q_INVOKABLE void sendMessage(const QString& content, const QString& type = "text");

signals:
    void connected();
    void disconnected();
    void errorOccurred(const QString& error);
    void messageReceived(const QString& sender, const QString& content, const QString& type, const QString& timestamp);

private slots:
    void onConnected();
    void onDisconnected();
    void onTextMessageReceived(const QString& message);
    void onSocketError(QAbstractSocket::SocketError error);

private:
    QWebSocket m_socket;
    QString m_username;
};

#endif // WEBSOCKETCLIENT_H
