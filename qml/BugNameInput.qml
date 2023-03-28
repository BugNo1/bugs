import QtQuick 2.15

Item {
    id: bugNameInput
    width: parent.width
    height: 35
    anchors.horizontalCenter: parent.horizontalCenter

    property string sourceFile: "../media/ladybug-middle.png"

    property var bugModel

    // needed since the GameStartOverlay is dynamically created and the model is not yet set during object creation
    onBugModelChanged: {
        if (typeof bugModel !== "undefined") {
            bugModel.nameChanged.connect(changeBugName)
            changeBugName()
        }
    }

    // should not be necessary for Qt 6.X
    // https://bugreports.qt.io/browse/QTBUG-29676
    Component.onDestruction: {
        bugModel.nameChanged.disconnect(changeBugName)
    }

    function changeBugName() {
        nameInput.text = bugModel.name
    }

    Image {
        id: bug
        width: 30
        height: 30
        rotation: 45
        source: sourceFile
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.rightMargin: 25
    }

    Rectangle {
        id: bugName
        width: parent.width - 130
        height: 35
        color: "tan"
        radius: 10
        border.width: 3
        border.color: "peru"
        anchors.left: bug.right
        anchors.leftMargin: 25
        anchors.rightMargin: 25

        MouseArea {
            anchors.fill: parent
            onClicked: { nameInput.focus = true }
        }

        TextInput {
            id: nameInput
            anchors.centerIn: parent
            font.family: "Tomson Talks"
            font.pixelSize: 30
            color: "white"
            onTextEdited: {
                bugModel.name = text
            }
        }
    }
}
