import QtQuick 2.15
import QtMultimedia 5.15
import QtQuick.Shapes 1.15

Item {
    id: itemExtraLife
    width: 50
    height: 50

    property bool itemActive: false
    visible: false

    // used for collision detection (hitbox is a circle)
    property int hitboxRadius: 25
    property int hitboxX: 0
    property int hitboxY: 0
    signal hit(bugModel: var)

    onHit: function(bugModel) {
        if (bugModel.lives !== bugModel.maxLives) {
            bugModel.updateLives(1)
            itemExtraLife.visible = false
            hitSound.source = ""
            hitSound.source = "../media/life-gained.wav"
            hitSound.play()
            startTimer()
        }
    }

    onItemActiveChanged: {
        if (itemActive) {
            startTimer()
        } else {
            timer.stop()
            itemExtraLife.visible = false
            dropSound.source = ""
            hitSound.source = ""
        }
    }

    function setRandomPosition() {
        x = Math.round(Math.random() * (mainWindow.width - 200)) + 100
        y = Math.round(Math.random() * (mainWindow.height - 300)) + 100
        hitboxX = x + width / 2
        hitboxY = y + height / 2
    }

    function startTimer() {
        timer.interval = Math.round(Math.random() * 30000) + 30000
        timer.start()
    }

    Timer {
        id: timer
        interval: 0
        running: false
        repeat: false
        onTriggered: {
            setRandomPosition()
            itemExtraLife.visible = true
            dropSound.source = ""
            dropSound.source = "../media/item-drop.wav"
            dropSound.play()
        }
    }

    Image {
        id: itemImage
        anchors.fill: parent
        source: "../media/extra-life.png"
    }

    Audio {
        id: dropSound
        source: "../media/item-drop.wav"
    }

    Audio {
        id: hitSound
        source: "../media/life-gained.wav"
    }
}
