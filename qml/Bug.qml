import QtQuick 2.15
import QtMultimedia 5.15
import QtQuick.Shapes 1.15

Item {
    id: bug
    width: 55
    height: 50

    property var sourceFiles: ["../media/ladybug-up.png", "../media/ladybug-middle.png", "../media/ladybug-down.png" ]
    property var bugModel

    // controller values - used as speed values for movement
    property real xAxisValue: 0
    property real yAxisValue: 0

    // used for collision detection (hitbox is a circle)
    property int hitboxRadius: 20
    property int hitboxX: 0
    property int hitboxY: 0

    property int sourceFilesIndex: 0
    property int timerCounter: 0

    Component.onCompleted: {
        bugModel.activeBugCollisionChanged.connect(onActiveBugCollisionChanged)
        bugModel.enabledChanged.connect(onBugEnabledChanged)
        bugModel.invincibilityEndWarning.connect(onInvincibilityEndWarning)
        setRandomPosition()
    }

    function onActiveBugCollisionChanged() {
        if (bugModel.activeBugCollision) {
            bugHit.play()
        }
    }

    function onBugEnabledChanged() {
        if (bugModel.enabled) {
            setRandomPosition()
            animationTimer.running = true
            bug.visible = true
        } else {
            animationTimer.running = false
            bugSound.stop()
            bug.visible = false
        }
    }

    function onInvincibilityEndWarning() {
        invincibilityShapePath.strokeColor = "red"
    }

    function setRandomPosition() {
        x = Math.round(Math.random() * (mainWindow.width - 200)) + 100
        y = Math.round(Math.random() * (mainWindow.height - 200)) + 100
        hitboxX = x + width / 2
        hitboxY = y + height / 2
    }

    Timer {
        id: animationTimer
        interval: 20
        running: true
        repeat: true
        onTriggered: {
            // must be here to be able to set-back the image when the bug stops
            changeImage()
            if (xAxisValue != 0.0 || yAxisValue != 0.0) {
                bugSound.source = "../media/bug-walk.wav"
                bugSound.play()
                move()
                rotate()
                timerCounter += 1
            } else {
                timerCounter = 0
                bugSound.stop()
                // workaround needed due to qt-multimedia bugs
                bugSound.source = ""
            }
        }
    }

    function changeImage() {
        if (timerCounter > 0) {
            // get axis with the higher speed
            var absAxisValue = Math.abs(yAxisValue)
            if (Math.abs(xAxisValue) >= Math.abs(yAxisValue)) {
                absAxisValue = Math.abs(xAxisValue)
            }

            var maxImageCounter = 3 // lowest speed
            var nextImageCounter = maxImageCounter - Math.round(maxImageCounter * absAxisValue) + 1
            if (timerCounter >= nextImageCounter) {
                // next image
                if (sourceFilesIndex < sourceFiles.length - 1) {
                    sourceFilesIndex += 1
                } else {
                    sourceFilesIndex = 0
                }
                timerCounter = 0
            }
            bugImage.source = sourceFiles[sourceFilesIndex]
        } else {
            bugImage.source = sourceFiles[1]
        }
    }

    function rotate() {
        var c = Math.sqrt(Math.pow(xAxisValue, 2.0) + Math.pow(yAxisValue, 2.0))
        var q = Math.pow(xAxisValue, 2.0) / c
        var p = c - q
        var h = Math.sqrt(p * q)
        var angle = 0

        if (xAxisValue >= 0 && yAxisValue < 0) {
            angle = Math.atan(h / p) * (180 / Math.PI)
        } else if (xAxisValue >= 0 && yAxisValue >= 0) {
            if (p == 0) {
                angle = 90
            } else {
                angle = 180 - (Math.atan(h / p) * (180 / Math.PI))
            }
        } else if (xAxisValue < 0 && yAxisValue >= 0) {
            if (p == 0) {
                angle = 270
            } else {
                angle = 180 + (Math.atan(h / p) * (180 / Math.PI))
            }
        } else if (xAxisValue < 0 && yAxisValue < 0) {
            angle = 360 - (Math.atan(h / p) * (180 / Math.PI))
        }

        // check for NaN
        if (angle == angle) {
            rotation = angle
        }
    }

    function move() {
        var offset = 10
        // x - stay inside the window
        if ((!((xAxisValue < 0) && (x + offset < 0))) && (!((xAxisValue >= 0) && (x + offset > mainWindow.width - 30))))
        {
            x += offset * xAxisValue
            hitboxX = x + width / 2
        }

        // y - stay inside the window
        if ((!((yAxisValue < 0) && (y + offset < 0))) && (!((yAxisValue >= 0) && (y + offset > mainWindow.height - 30))))
        {
            y += offset * yAxisValue
            hitboxY = y + height / 2
        }
    }

    Image {
        id: bugImage
        anchors.fill: parent
        source: sourceFiles[1]
    }

    Shape {
        width: 56
        height: 56
        anchors.centerIn: parent
        visible: bugModel.invincible
        onVisibleChanged: {
            if (visible) {
                invincibilityShapePath.strokeColor = "gold"
            }
        }

        ShapePath {
            id: invincibilityShapePath
            fillColor: "transparent"
            strokeColor: "gold"
            strokeWidth: 3
            PathAngleArc {
                centerX: 27
                centerY: 30
                radiusX: 28
                radiusY: 28
                startAngle: 0
                sweepAngle: 360
            }
        }
    }

    // enable for debugging
    /*Shape {
        width: hitboxRadius * 2
        height: hitboxRadius * 2
        anchors.centerIn: parent
        ShapePath {
            fillColor: "transparent"
            strokeColor: "red"
            PathAngleArc {
                centerX: hitboxRadius
                centerY: hitboxRadius
                radiusX: hitboxRadius
                radiusY: hitboxRadius
                startAngle: 0
                sweepAngle: 360
            }
        }
    }*/

    Audio {
        id: bugSound
        source: "../media/bug-walk.wav"
    }

    SoundEffect {
        id: bugHit
        source: "../media/hit.wav"
    }
}
