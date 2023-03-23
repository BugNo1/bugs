import QtQuick 2.15
import QtMultimedia 5.15
import QtQuick.Shapes 1.15
import QtQuick.Layouts 1.15

Item {
    id: lifeIndicator
    height: parent.height - 10
    width: 200

    property string sourceFile: "media/ladybug-middle.png"
    property var lifeObjects: []
    property var bugModel

    onBugModelChanged: {
        if (typeof bugModel !== "undefined") {
            bugModel.maxLivesChanged.connect(onMaxLivesChanged)
            bugModel.livesChanged.connect(onLivesChanged)
        }
    }

    function onMaxLivesChanged() {
        for (var i = 0; i < bugModel.maxLives; i++)  {
            var currentObject = Qt.createQmlObject('import QtQuick 2.15; Image { y: 4; width: 30; height: 30; rotation: 45; source: "' + sourceFile + '"}',
                                                   lifeIndicator,
                                                   "lifeindicator");
            currentObject.x = Math.floor(width / (bugModel.maxLives + 1)) * (i + 1) - 15
            lifeObjects.push(currentObject)
        }
    }

    function onLivesChanged() {
        // play different sound when life lost or life gained
        for (var i = 0; i < bugModel.lives; i++) {
            lifeObjects[i].visible = true
        }
        for (var j = bugModel.lives; j < bugModel.maxLives; j++) {
            lifeObjects[j].visible = false
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
}
