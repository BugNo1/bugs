import QtQuick 2.15
import QtMultimedia 5.15
import QtQuick.Shapes 1.15
import QtQuick.Layouts 1.15

Item {
    id: lifeIndicator
    width: 200
    height: parent.height

    property string sourceFile: "../media/ladybug-middle.png"
    property var bugModel
    property var player

    property var lifeObjects: []

    Component.onCompleted: {
        bugModel.maxLivesChanged.connect(onMaxLivesChanged)
        bugModel.livesChanged.connect(onLivesChanged)
        bugModel.lifeLost.connect(onLifeLost)
        bugModel.lifeGained.connect(onLifeGained)
    }

    function onMaxLivesChanged() {
        for (var i = 0; i < bugModel.maxLives; i++)  {
            var currentObject = Qt.createQmlObject('import QtQuick 2.15; Image { y: 29; width: 30; height: 30; rotation: 45; source: "' + sourceFile + '"}',
                                                   lifeIndicator,
                                                   "lifeindicator");
            currentObject.x = Math.floor(width / (bugModel.maxLives + 1)) * (i + 1) - 15
            lifeObjects.push(currentObject)
        }
    }

    function onLivesChanged() {
        for (var i = 0; i < bugModel.lives; i++) {
            lifeObjects[i].visible = true
        }
        for (var j = bugModel.lives; j < bugModel.maxLives; j++) {
            lifeObjects[j].visible = false
        }
    }

    function onLifeLost() {
        birdEating.source = ""
        birdEating.source = "../media/bird-eating.wav"
        birdEating.play()
    }

    function onLifeGained() {
        // play sound for gaining life
    }

    Text {
        id: name
        width: parent.width
        text: player.name
        font.family: "Tomson Talks"
        font.pixelSize: 30
        color: "white"
        anchors.top: parent.top
        horizontalAlignment: Text.AlignHCenter
    }

    Rectangle {
        id: background
        width: parent.width
        height: 40
        anchors.top: name.bottom
        color: "tan"
        radius: 10
        border.width: 3
        border.color: "peru"
    }

    Text {
        id: lastResult
        width: parent.width
        text: player.timeAchievedText + " (Level: " + player.levelAchieved + ")"
        font.family: "Tomson Talks"
        font.pixelSize: 22
        color: "white"
        visible: !bugModel.enabled
        anchors.top: background.bottom
        horizontalAlignment: Text.AlignHCenter
    }

    Audio {
        id: birdEating
        source: "../media/bird-eating.wav"
    }
}
