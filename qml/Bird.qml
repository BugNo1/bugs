import QtQuick 2.15
import QtMultimedia 5.15
import QtQuick.Shapes 1.15

Item {
    id: bird
    width: 600
    height: 444

    // used for collision detection (hitbox is a circle)
    property int hitboxRadius: 50
    property int hitboxX: 0
    property int hitboxY: 0
    property bool selfDestroy: false

    property int animationDuration: 0
    property int animationDurationMax: 10000
    property int nextAnimationInterval: 0
    property int targetX: 0
    property int targetY: 0

    transform: Rotation { origin.x: 0; origin.y: 0; angle: 0 }

    Component.onCompleted: {
        // hide
        x = - bird.width
        y = - bird.height

        var multiplier = (Math.random() / 2.0) + 0.5
        width = Math.floor(width * multiplier)
        height = Math.floor(height * multiplier)
        hitboxRadius = Math.floor(hitboxRadius * multiplier)
        animationDuration = Math.floor(animationDurationMax * multiplier)
        nextAnimationInterval = animationDuration * 2
        nextAnimationTimer.interval = nextAnimationInterval
        moveBird()
    }

    Timer {
        id: nextAnimationTimer
        running: true
        repeat: true
        onTriggered: {
            if (selfDestroy) {
                bird.destroy()
            } else {
                moveBird()
            }
        }
    }

    function moveBird() {
        // get start quadrant
        var startQuadrant = Math.round(Math.random() * 5) + 1

        // get target quadrant
        var targetQuadrant = 0
        switch(startQuadrant) {
            case 1: {
                targetQuadrant = 3
                break
            }
            case 2: {
                targetQuadrant = 4
                break
            }
            case 3: {
                targetQuadrant = 1
                break
            }
            case 4: {
                targetQuadrant = 2
                break
            }
            case 5: {
                targetQuadrant = 6
                break
            }
            case 6: {
                targetQuadrant = 5
                break
            }
        }

        // set start position
        var result = getRandomPosition(startQuadrant)
        x = result.x
        y = result.y
        hitboxX = x + width / 2
        hitboxY = y + hitboxRadius

        // set target position
        result = getRandomPosition(targetQuadrant)
        targetX = result.x
        targetY = result.y

        // set angle
        var angle = Math.atan2(targetY - y, targetX - x) * 180 / Math.PI;
        bird.transform[0].origin.x = width/2
        bird.transform[0].origin.y = hitboxRadius
        bird.transform[0].angle = angle + 90

        // start animation
        birdMovement.running = true

        // play sound
        birdSound.source = ""
        birdSound.source = "../bugs-media/bird.wav"
        birdSound.play()
    }

    function getRandomPosition(quadrant) {
        // quadrant:
        // 1: top left
        // 2: top right
        // 3: bottom right
        // 4: bottom left
        // 5: left
        // 6: right

        var x1 = 0
        var x2 = 0
        var y1 = 0
        var y2 = 0

        switch(quadrant) {
            case 1: {
                x1 = - bird.width
                x2 = (mainWindow.width / 2) - bird.width
                y1 = - bird.height
                y2 = - bird.height
                break
            }
            case 2: {
                x1 = mainWindow.width / 2
                x2 = mainWindow.width
                y1 = - bird.height
                y2 = - bird.height
                break
            }
            case 3: {
                x1 = mainWindow.width / 2
                x2 = mainWindow.width
                y1 = mainWindow.height + bird.height
                y2 = mainWindow.height + bird.height
                break
            }
            case 4: {
                x1 = - bird.width
                x2 = (mainWindow.width / 2) - bird.width
                y1 = mainWindow.height + bird.height
                y2 = mainWindow.height + bird.height
                break
            }
            case 5: {
                x1 = - (bird.height + 300)
                x2 = - (bird.height + 300)
                y1 = 0
                y2 = mainWindow.height
                break
            }
            case 6: {
                x1 = mainWindow.width + bird.height
                x2 = mainWindow.width + bird.height
                y1 = 0
                y2 = mainWindow.height
                break
            }
        }

        return {
            x: Math.round(Math.random() * (x2 - x1 + 1)) + x1,
            y: Math.round(Math.random() * (y2 - y1 + 1)) + y1
        }
    }

    Image {
        id: birdImage
        anchors.fill: parent
        source: "../bugs-media/bird.png"
    }

    // enable for debugging
    /*Shape {
        width: hitboxRadius * 2
        height: hitboxRadius * 2
        x: (bird.width / 2) - (width / 2)
        y: 0
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
        id: birdSound
        source: "../bugs-media/bird.wav"
    }

    ParallelAnimation {
        id: birdMovement
        NumberAnimation { target: bird; property: "x"; to: targetX; duration: animationDuration }
        NumberAnimation { target: bird; property: "y"; to: targetY; duration: animationDuration }
    }


    onXChanged: {
        hitboxX = x + width / 2
    }

    onYChanged: {
        hitboxY = y + hitboxRadius
    }
}
