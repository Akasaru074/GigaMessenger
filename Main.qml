import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Messenger.Models 1.0

Window {
    maximumWidth: 1080
    maximumHeight: 720
    minimumWidth: 900
    minimumHeight: 600
    visible: true
    title: qsTr("Giga Messenger")

    MessageModel {
        id: messageModel
        Component.onCompleted: {
            addMessage("Test message", false, "text");
        }
    }

    ListView {
        id: chatView
        anchors.fill: parent
        anchors.bottomMargin: inputArea.height + 10
        spacing: 8

        model: messageModel

        delegate: Rectangle {
            width: chatView.width
            height: Math.max(40, contentText.implicitHeight + 16)
            radius: 10
            color: isOwn ? "#d1f0da" : "#f0f0f0"
            border.color: isOwn ? "#c0e6a5" : "#e0e0e0"
            border.width: 1

            Text {
                id: contentText
                text: content
                wrapMode: Text.Wrap
                width: parent.width - 20
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: isOwn ? undefined : parent.left
                anchors.right: isOwn ? parent.right : undefined
                anchors.margins: 10
                font.pixelSize: 14
                color: isOwn ? "#000000" : "#333333"
            }
        }

        onCountChanged: {
            scrollToIndex(chatView.count - 1)
        }

        function scrollToIndex(index) {
            chatView.positionViewAtIndex(index, ListView.AtTop)
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

        messageModel.addMessage(inputField.text, true, "text");

        inputField.text = "";

    }

}
