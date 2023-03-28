import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtMultimedia 5.15

Item {
    id: gameEndOverlay
    width: 400
    height: 570
    anchors.centerIn: parent

    property var signalStart

    function checkStart() {
        if (button1.buttonState && button2.buttonState) {
            signalStart()
            gameEndOverlay.destroy()
        }
    }

    /*Component.onCompleted: {
        countdownSound.play()
        opacityAnimation.start()
    }*/

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
        text: "Ende"
        font.family: "Tomson Talks"
        font.pixelSize: 100
        color: "white"
        horizontalAlignment: Text.AlignHCenter
    }

    Rectangle {
        id: highscores
        width: 300
        height: 300
        color: "white"
        radius: 10
        border.width: 3
        border.color: "peru"
        anchors.top: headline.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 25
        anchors.bottomMargin: 25
    }

    Text {
        id: againText
        text: "Nochmal spielen:"
        font.family: "Tomson Talks"
        font.pixelSize: 30
        color: "white"
        width: parent.width
        anchors.top: highscores.bottom
        anchors.margins: 25
        horizontalAlignment: Text.AlignHCenter
    }

    RowLayout {
        id: layout
        width: parent.width
        height: 50
        anchors.left: parent.left
        anchors.top: againText.bottom
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

    Audio {
        id: newHighScoreSound
        //source: "../media/countdown.wav"
    }
}
