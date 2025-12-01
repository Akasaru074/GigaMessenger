import QtQuick
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
            addMessage("Hello!", false, "text");
            addMessage("Whasup?", true, "text")
        }
    }

    ListView {
        anchors.fill: parent
        model: messageModel
        delegate: Rectangle {
            width: ListView.view.width
            height: 40
            color: isOwn ? "#d1f0da" : "#f0f0f0"
            Text {
                text: content + " (" + timestamp + ")"
                anchors.centerIn: parent
            }
        }
    }

}
