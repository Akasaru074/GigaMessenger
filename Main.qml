import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

import Messenger.Models 1.0
import Messenger.Network 1.0

Window {
    id: window
    maximumWidth: 1080
    maximumHeight: 720
    minimumWidth: 900
    minimumHeight: 600
    visible: true
    title: "Giga Messenger" + (myName ? " - " + myName : "")

    property string myName: ""

    Component.onCompleted: {
        console.log("QML: Window loaded successfully")
    }

    MessageModel {
        id: messageModel
    }

    ListModel {
        id: onlineUsersModel
    }

    WebSocketClient {
        id: wsClient

        onConnected: {
            console.log("QML: Connected to server")
        }

        onMessageReceived: (sender, content, type, timestamp) => {
            console.log("QML: Received message: ", sender, content, type)
            messageModel.addMessageEx(sender, content, false, type, timestamp)
        }

        onErrorOccurred: (error) => {
            console.error("Error: ", error)
        }

        onOnlineUsersUpdated: (usernames) => {
            onlineUsersModel.clear();
            for (let i = 0; i < usernames.length; i++) {
                onlineUsersModel.append({ name: usernames[i] });
            }
        }

    }

    Dialog {
        id: nameDialog
        title: "Name"
        standardButtons: Dialog.Ok
        modal: true
        visible: true

        Column {
            Text { text: "Enter your name:" }
            TextField {
                id: nameField
                placeholderText: "Your name"
                text: "User"
                selectByMouse: true
                onAccepted: nameDialog.accept()
            }
        }

        onAccepted: {
            myName = nameField.text
            wsClient.connectToServer("ws://localhost:8080", myName)
        }

    }

    ListView {
        id: chatView
        anchors {
            top: parent.top
            left: parent.left
            bottom: inputArea.top
            right: userListPanel.left
        }

        anchors.leftMargin: 10
        anchors.rightMargin: 10
        spacing: 8
        model: messageModel

        delegate: Column {
            width: chatView.width
            spacing: 4

            Text {
                text: sender
                font.bold: true
                font.pixelSize: 12
                color: isOwn ? "#008000" : "#333333"
                anchors.horizontalCenter: isOwn ? undefined : parent.left
                anchors.right: isOwn ? parent.right : undefined
                anchors.left: isOwn ? undefined : parent.left
                anchors.leftMargin: 10
                anchors.rightMargin: 10
            }

            Rectangle {
                width: Math.min(chatView.width * 0.75, contentText.implicitWidth + 20)
                height: Math.max(40, contentText.implicitHeight + 16)
                radius: 10
                color: isOwn ? "#dcf8c6" : "#ffffff"
                border.color: isOwn ? "#c0e6a5" : "#e0e0e0"
                border.width: 1

                anchors.left: isOwn ? undefined : parent.left
                anchors.right: isOwn ? parent.right : undefined
                Text {
                    id: contentText
                    text: content
                    wrapMode: Text.Wrap
                    width: parent.width - 20
                    anchors.centerIn: parent
                    font.pixelSize: 14
                    color: isOwn ? "#000000" : "#333333"
                }
            }

            Text {
                text: timestamp
                font.pixelSize: 10
                color: "#888"
                anchors.horizontalCenter: isOwn ? undefined : parent.left
                anchors.right: isOwn ? parent.right : undefined
                anchors.left: isOwn ? undefined : parent.left
                anchors.leftMargin: 10
                anchors.rightMargin: 10
            }

        }

        onCountChanged: {
            Qt.callLater(function() {
                chatView.positionViewAtEnd();
            })
        }

    }

    Rectangle {
        id: inputArea
        height: 50
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        color: "#f0f0f0"
        border.color: "#ccc"

        RowLayout {
            anchors.fill: parent
            anchors.margins: 6

            TextField {
                id: inputField
                Layout.fillWidth: true
                placeholderText: "Enter message"
                font.pixelSize: 14
                selectByMouse: true
                onAccepted: sendMessage()
            }

            Button {
                id: sendButton
                text: "Send"
                font.pixelSize: 16
                onClicked: sendMessage()
            }

        }

    }

    function sendMessage() {
        if (inputField.text.trim() === "") return;

        wsClient.sendMessage(inputField.text, "text");

        messageModel.addMessageEx(nameField.text, inputField.text, true, "text", new Date().toTimeString().substr(0,5));

        inputField.text = "";
    }

    Rectangle {
        id: userListPanel
        width: 180
        anchors {
            top: parent.top
            right: parent.right
            bottom: inputArea.top
        }
        color: "#f9f9f9"
        border.color: "#ddd"

        Text {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Online (" + onlineUsersModel.count + ")"
            font.bold: true
            padding: 8
        }

        ListView {
            anchors.fill: parent
            anchors.topMargin: 30
            model: onlineUsersModel
            clip: true
            delegate: Rectangle {
                width: parent.width
                height: 30
                color: index % 2 ? "#f0f0f0" : "transparent"
                Text {
                    text: name
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    font.pointSize: 13
                }
            }
        }
    }

}
