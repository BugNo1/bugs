import QtQuick 2.15

Item {
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

    function changeBugName() {
        bugNameInput.text = bugModel.name
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

        // must have minimun length or focus must be set by clicking next to the textinout field
        // currently the textfield can't be edited when it's empty
        TextInput {
            id: bugNameInput
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
