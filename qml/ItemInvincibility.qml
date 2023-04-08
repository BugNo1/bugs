import QtQuick 2.15
import QtMultimedia 5.15
import QtQuick.Shapes 1.15

Item {
    id: itemInvincibility
    width: 50
    height: 50

    property bool itemActive: false
    visible: false

    // used for collision detection (hitbox is a circle)
    property int hitboxRadius: 25
    property int hitboxX: 0
    property int hitboxY: 0
    signal hit(bugModel: var)

    property int invincibilityDuration: 0

    onHit: function(bugModel) {
        if (! bugModel.invincible) {
            bugModel.startInvincibility(invincibilityDuration * 1000)
            itemInvincibility.visible = false
            hitSound.source = ""
            hitSound.source = "../media/invincible.wav"
            hitSound.play()
            startTimer()
        }
    }

    onItemActiveChanged: {
        if (itemActive) {
            startTimer()
        } else {
            timer.stop()
            itemInvincibility.visible = false
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

    function setInvincibilityDuration() {
        invincibilityDuration = (Math.round(Math.random() * 5) + 1) * 5
    }

    Timer {
        id: timer
        interval: 0
        running: false
        repeat: false
        onTriggered: {
            setRandomPosition()
            setInvincibilityDuration()
            itemInvincibility.visible = true
            dropSound.source = ""
            dropSound.source = "../media/item-drop.wav"
            dropSound.play()
        }
    }

    Image {
        id: itemImage
        anchors.fill: parent
        source: "../media/protection.png"
    }

    Text {
        id: durationText
        text: invincibilityDuration
        font.family: "Courier"
        font.pixelSize: 25
        font.bold: true
        color: "black"
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Audio {
        id: dropSound
        source: "../media/item-drop.wav"
    }

    Audio {
        id: hitSound
        source: "../media/invincible.wav"
    }
}
