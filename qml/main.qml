import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.15
import QtMultimedia 5.15
import QtQml.StateMachine 1.15 as DSM

Window {
    id: mainWindow
    width: 1280
    height: 800
    visible: true
    title: qsTr("Bugs")

    property var bugs: [bug1, bug2]
    property var birds: []
    property var overlay

    Image {
        id: background
        source: "../media/bg.jpg"
        anchors.fill: parent
    }

    Bug {
        id: bug1
        Connections {
            target: QJoysticks
            function onAxisChanged() {
                bug1.xAxisValue = filterAxis(QJoysticks.getAxis(0, 0))
                bug1.yAxisValue = filterAxis(QJoysticks.getAxis(0, 1))
            }
        }
        Component.onCompleted: {
            var bugModel = Qt.createQmlObject('import BugModel 1.0; BugModel {}', bug1, "bugmodel1")
            bug1.bugModel = bugModel
            bug1LifeIndicator.bugModel = bugModel
        }
    }

    Bug {
        id: bug2
        sourceFiles: ["../media/ladybug-up-blue.png", "../media/ladybug-middle-blue.png", "../media/ladybug-down-blue.png" ]
        Connections {
            target: QJoysticks
            function onAxisChanged() {
                bug2.xAxisValue = filterAxis(QJoysticks.getAxis(1, 0))
                bug2.yAxisValue = filterAxis(QJoysticks.getAxis(1, 1))
            }
        }
        Component.onCompleted: {
            var bugModel = Qt.createQmlObject('import BugModel 1.0; BugModel {}', bug2, "bugmodel2")
            bug2.bugModel = bugModel
            bug2LifeIndicator.bugModel = bugModel
        }
    }

    // filter out jitter and ensure that the value goes back to 0.0 after the joystick went back to middle position
    function filterAxis(axisValue) {
        if ((axisValue <= -0.07) || (axisValue >= 0.07)) {
            return axisValue
        }
        return 0.0
    }

    RowLayout {
        id: layout
        width: mainWindow.width
        height: 70
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        // stay on top of everything
        z: 1000
        anchors.margins: 25
        LifeIndicator {
            id: bug1LifeIndicator
            Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
        }
        TimeLevelIndicator {
            id: timeLifeIndicator
            Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
        }
        LifeIndicator {
            id: bug2LifeIndicator
            Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
            sourceFile: "../media/ladybug-middle-blue.png"
        }
    }

    // game logic
    // states
    // 1. initial state: two bugs, background, bug lives indicators, time: 00:00, level: 0, no bird
    // 2. game state: green rectangle button was pressed on both controller,
    //    timer running for clock, timer running for level-up, new bird on each new level,
    //    when hit, remove one bug from lives indicator
    //    play sound when bird starts a fly over
    // 3. when both bugs have no life left, stop all birds, show the winner and the level and the time for both

    property double startTime: 0
    property int currentLevel: 0
    property int levelDuration: 30
    property int bugsMaxLives: 3

    signal signalResetGame()
    signal signalStartGame()
    signal signalStopGame()

    DSM.StateMachine {
        id: stateMachine
        initialState: resetState
        running: true

        DSM.State {
            id: resetState
            DSM.SignalTransition {
                targetState: gameRunningState
                signal: signalStartGame
            }
            onEntered: resetGame()
        }
        DSM.State {
            id: gameRunningState
            DSM.SignalTransition {
                targetState: gameStoppedState
                signal: signalStopGame
            }
            onEntered: startGame()
        }
        DSM.State {
            id: gameStoppedState
            DSM.SignalTransition {
                targetState: resetState
                signal: signalResetGame
            }
            onEntered: stopGame()
        }
    }

    function resetGame() {
        console.log("Resetting game...")
        // stop all birds (maybe)
        // remove all birds from birds list
        // maybe put in names - when none are set

        currentLevel = 1
        timeLifeIndicator.setLevel(currentLevel)
        timeLifeIndicator.setTime("00:00")

        // initialize bug models
        for (var bugIndex = 0; bugIndex < bugs.length; bugIndex++) {
            bugs[bugIndex].bugModel.maxLives = bugsMaxLives
            bugs[bugIndex].bugModel.lives = bugsMaxLives
            bugs[bugIndex].bugModel.invincible = false
            bugs[bugIndex].bugModel.activeBugCollision = false
            bugs[bugIndex].bugModel.activeBirdCollision = false
            bugs[bugIndex].bugModel.enabled = true
        }

        overlay = Qt.createQmlObject('GameStartOverlay {}', mainWindow, "overlay")
        overlay.bug1Model = bugs[0].bugModel
        overlay.bug2Model = bugs[1].bugModel
        overlay.signalStartGame = signalStartGame
    }

    function startGame() {
        console.log("Starting game...")

        // add countdown before starting (countdown state?)

        overlay.destroy()
        startTime = new Date().getTime()
        gameTimer.start()
        collisionDetectionTimer.start()
        createBird()
    }

    function stopGame() {
        console.log("Stopping game...")
        // stop game timer
        // stop level timer
        // stop all birds
        // show winner
        // show highscore list... highlight new entries
        // two buttons: 1. Nochmal, 2. Schluss für heute oder Feierabend

        gameTimer.stop()
        collisionDetectionTimer.stop()
    }

    Timer {
        id: gameTimer
        interval: 100;
        running: false;
        repeat: true;
        onTriggered: {
            var currentTime = new Date().getTime() - startTime
            updateClock(currentTime)
            updateLevel(currentTime)
        }
    }

    function updateClock(currentTime: double) {
        timeLifeIndicator.setTime(getTimeString(currentTime))
    }

    function updateLevel(currentTime: double) {
        var newLevel = 1 + Math.floor(currentTime / 1000 / levelDuration)
        if (newLevel != currentLevel) {
            timeLifeIndicator.setLevel(newLevel)
            createBird()
            currentLevel = newLevel
        }
    }

    function getTimeString(time) {
        var s = Math.floor((time / 1000) % 60).toString().padStart(2, "0")
        var m = Math.floor(time / 1000 / 60).toString().padStart(2, "0")
        return m + ":" + s
    }

    function createBird() {
        var newBird = Qt.createQmlObject('Bird {}', mainWindow, "bird")
        birds.push(newBird)
    }

    // collision detection
    Timer {
        id: collisionDetectionTimer
        interval: 20;
        running: false;
        repeat: true;
        onTriggered: {
            detectAllCollision()
        }
    }

    function detectAllCollision() {
        // bug vs. bug collision
        if (bugs[0].bugModel.enabled && bugs[1].bugModel.enabled) {
            var colliding = detectCollision(bug1, bug2)
            bugs[0].bugModel.bugCollision(1, colliding)
            // only one bug needs to know that a collision happened (so only one bug collision sound is played)
            //bugs[1].bugModel.bugCollision(0, colliding)
        }

        // bug vs. bird collision
        for (var bugIndex = 0; bugIndex < bugs.length; bugIndex++) {
            for (var birdIndex = 0; birdIndex < birds.length; birdIndex++) {
                colliding = detectCollision(bugs[bugIndex], birds[birdIndex])
                bugs[bugIndex].bugModel.birdCollision(birdIndex, colliding)
            }
        }
    }

    function detectCollision(item1, item2) {
        var dx = item1.hitboxX - item2.hitboxX
        var dy = item1.hitboxY - item2.hitboxY
        var distance = Math.sqrt(dx * dx + dy * dy)
        var colliding = distance < item1.hitboxRadius + item2.hitboxRadius
        return colliding
    }
}
