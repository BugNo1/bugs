import QtQuick 2.15
import QtQuick.Layouts 1.15

Item {
    id: gameStartOverlay
    width: 400
    height: 360
    anchors.centerIn: parent

    property var signalStart

    function checkStart() {
        if (button1.buttonState && button2.buttonState) {
            signalStart()
            gameStartOverlay.destroy()
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

    PlayerNameInput {
        id: player1Input
        player: GameData.player1
        anchors.top: headline.bottom
        anchors.margins: 25
    }

    PlayerNameInput {
        id: player2Input
        sourceFile: "../media/ladybug-middle-blue.png"
        player: GameData.player2
        anchors.top: player1Input.bottom
        anchors.margins: 25
    }

    Text {
        id: pressStartText
        text: "Zum Start bitte drücken:"
        font.family: "Tomson Talks"
        font.pixelSize: 30
        color: "white"
        width: parent.width
        anchors.top: player2Input.bottom
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
                checkStart()
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
                checkStart()
            }
        }
    }
}
