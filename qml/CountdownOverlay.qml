import QtQuick 2.15
import QtMultimedia 5.15

Item {
    id: countdownOverlay
    width: 400
    height: 400
    anchors.centerIn: parent

    property int currentNumber: 5
    property var signalStart

    Component.onCompleted: {
        countdownSound.play()
        opacityAnimation.start()
    }

    Text {
        id: countdownText
        anchors.fill: parent
        text: currentNumber
        font.pixelSize: 200
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        OpacityAnimator {
            id: opacityAnimation
            target: countdownText
            from: 1
            to: 0
            duration: 900
        }
    }

    Timer {
        id: gameTimer
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            currentNumber -= 1
            if (currentNumber > 0) {
                countdownText.text = currentNumber
                countdownSound.play()
            } else if (currentNumber == 0) {
                countdownText.text = "Start"
                countdownSound.source = "../common-media/countdown-end.wav"
                countdownSound.play()
            } else if (currentNumber < 0) {
                signalStart()
                countdownOverlay.destroy()
            }
            opacityAnimation.start()
        }
    }

    SoundEffect {
        id: countdownSound
        source: "../common-media/countdown.wav"
    }
}
