import QtQuick 2.15
import QtQuick.Layouts 1.15

Item {
    width: 400
    height: 360

    anchors.centerIn: parent

    property var bug1Model
    property var bug2Model
    property var startGameSignal

    function checkStartGame() {
        if (button1.buttonState && button2.buttonState) {
            startGameSignal()
        }
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "tan"
        radius: 10
        border.width: 3
        border.color: "peru"
    }

    Text {
        id: headline
        width: parent.width
        text: "BUGS"
        font.family: "Tomson Talks"
        font.pixelSize: 100
        color: "white"
        horizontalAlignment: Text.AlignHCenter
    }

    BugNameInput {
        id: bug1Input
        bugModel: bug1Model
        anchors.top: headline.bottom
        anchors.margins: 25
    }

    BugNameInput {
        id: bug2Input
        sourceFile: "media/ladybug-middle-blue.png"
        bugModel: bug2Model
        anchors.top: bug1Input.bottom
        anchors.margins: 25
    }

    Text {
        id: pressStartText
        text: "Zum Start bitte drücken:"
        font.family: "Tomson Talks"
        font.pixelSize: 30
        color: "white"
        width: parent.width
        anchors.top: bug2Input.bottom
        anchors.margins: 25
        horizontalAlignment: Text.AlignHCenter
    }

    RowLayout {
        id: layout
        width: parent.width
        height: 50
        anchors.left: parent.left
        anchors.top: pressStartText.bottom
        anchors.topMargin: 25
        CrossButton {
            id: button1
            width: 50
            height: 50
            borderColor: "red"
            Layout.alignment: Qt.AlignCenter
            Connections {
                target: QJoysticks
                function onButtonChanged() {
                    button1.buttonPressed = QJoysticks.getButton(0, 0)
                }
            }
            onButtonStateChanged: {
                checkStartGame()
            }
        }
        CrossButton {
            id: button2
            width: 50
            height: 50
            borderColor: "blue"
            Layout.alignment: Qt.AlignCenter
            Connections {
                target: QJoysticks
                function onButtonChanged() {
                    button2.buttonPressed = QJoysticks.getButton(1, 0)
                }
            }
            onButtonStateChanged: {
                checkStartGame()
            }
        }
    }


}
