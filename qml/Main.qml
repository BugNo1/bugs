import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.15
import QtMultimedia 5.15
import QtQml.StateMachine 1.15 as DSM

import "../common-qml"
import "../common-qml/CommonFunctions.js" as Functions

Window {
    id: mainWindow
    width: 1280
    height: 800
    visible: true
    title: qsTr("Bugs")

    property var bugs: [bug1, bug2]
    property var birds: []
    property var collectibleItems: [itemInvincibility, itemExtraLife, itemSpeed]
    property var overlay

    Component.onCompleted: {
        setBackground()
        BugModel1.enabledChanged.connect(onBug1EnabledChanged)
        BugModel2.enabledChanged.connect(onBug2EnabledChanged)
    }

    Image {
        id: background
        anchors.fill: parent
    }

    function setBackground() {
        background.source = bgPath + "bg" + (Math.round(Math.random() * 10) + 1).toString().padStart(2, "0") + ".jpg"
    }

    ItemInvincibility {
        id: itemInvincibility
        itemActive: false
    }

    CollectibleItem {
        id: itemExtraLife
        itemImageSource: "../common-media/extra-life.png"
        hitSoundSource: "../common-media/life-gained.wav"
        minimalWaitTime: 30000
        itemActive: false
    }

    ItemSpeed {
        id: itemSpeed
        minimalSpeed: 50
        minimalWaitTime: 30000
        itemActive: false
    }

    Bug {
        id: bug1
        bugModel: BugModel1
        Connections {
            target: QJoysticks
            function onAxisChanged() {
                bug1.xAxisValue = Functions.filterAxis(QJoysticks.getAxis(0, 0))
                bug1.yAxisValue = Functions.filterAxis(QJoysticks.getAxis(0, 1))
            }
        }
    }

    Bug {
        id: bug2
        bugModel: BugModel2
        sourceFiles: ["../bugs-media/ladybug-up-blue.png", "../bugs-media/ladybug-middle-blue.png", "../bugs-media/ladybug-down-blue.png" ]
        Connections {
            target: QJoysticks
            function onAxisChanged() {
                bug2.xAxisValue = Functions.filterAxis(QJoysticks.getAxis(1, 0))
                bug2.yAxisValue = Functions.filterAxis(QJoysticks.getAxis(1, 1))
            }
        }
    }

    RowLayout {
        id: layout
        width: mainWindow.width
        height: 70
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        // stay on top of everything
        z: 1000
        anchors.bottomMargin: 25
        LifeIndicator {
            id: bug1LifeIndicator
            model: BugModel1
            player: GameData.player1
            imageSource: "../bugs-media/ladybug-middle.png"
            lifeLostAudioSource: "../bugs-media/bird-eating.wav"
            Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
        }
        TimeLevelIndicator {
            id: timeLevelIndicator
            Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
        }
        LifeIndicator {
            id: bug2LifeIndicator
            model: BugModel2
            player: GameData.player2
            imageSource: "../bugs-media/ladybug-middle-blue.png"
            lifeLostAudioSource: "../bugs-media/bird-eating.wav"
            Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
        }
    }

    // game logic
    property double startTime: 0
    property double currentTime: 0
    property int currentLevel: 0
    property int levelDuration: 30
    property int bugsMaxLives: 3

    GameStateMachine {
        id: gameStateMachine
        gameResetAction: mainWindow.gameResetAction
        gameCountdownAction: mainWindow.gameCountdownAction
        gameStartAction: mainWindow.gameStartAction
        gameStopAction: mainWindow.gameStopAction
    }

    function gameResetAction() {
        console.log("Resetting game...")

        setBackground()

        currentLevel = 1
        currentTime = 0
        timeLevelIndicator.setLevel(currentLevel)
        timeLevelIndicator.setTime(currentTime)

        // initialize models
        BugModel1.initialize(bugsMaxLives)
        BugModel2.initialize(bugsMaxLives)
        GameData.initialize()

        overlay = Qt.createQmlObject('import "../common-qml"; GameStartOverlay {}', mainWindow, "overlay")
        overlay.gameName = "BUGS"
        overlay.player1ImageSource = "../bugs-media/ladybug-middle.png"
        overlay.player2ImageSource = "../bugs-media/ladybug-middle-blue.png"
        overlay.signalStart = gameStateMachine.signalStartCountdown
    }

    function gameCountdownAction() {
        console.log("Starting countdown...")

        GameData.savePlayerNames()
        overlay = Qt.createQmlObject('import "../common-qml"; CountdownOverlay {}', mainWindow, "overlay")
        overlay.signalStart = gameStateMachine.signalStartGame
    }

    function gameStartAction() {
        console.log("Starting game...")

        startTime = new Date().getTime()
        gameTimer.start()
        collisionDetectionTimer.start()

        // activate collectible items
        for (var itemIndex = 0; itemIndex < collectibleItems.length; itemIndex++) {
            collectibleItems[itemIndex].itemActive = true
        }

        createBird()
    }

    function gameStopAction() {
        console.log("Stopping game...")

        gameTimer.stop()
        collisionDetectionTimer.stop()

        // stop all birds
        for (var birdIndex = 0; birdIndex < birds.length; birdIndex++) {
            birds[birdIndex].selfDestroy = true
        }
        birds = []

        // disable collectible items
        for (var itemIndex = 0; itemIndex < collectibleItems.length; itemIndex++) {
            collectibleItems[itemIndex].itemActive = false
        }

        GameData.updateHighscores()
        GameData.saveHighscores()

        overlay = Qt.createQmlObject('import "../common-qml"; GameEndOverlay { gameType: GameEndOverlay.GameType.PvP }', mainWindow, "overlay")
        overlay.signalStart = gameStateMachine.signalResetGame
    }

    Timer {
        id: gameTimer
        interval: 100
        running: false
        repeat: true
        onTriggered: {
            currentTime = new Date().getTime() - startTime
            updateClock()
            updateLevel()
        }
    }

    function updateClock() {
        timeLevelIndicator.setTime(currentTime)
    }

    function updateLevel() {
        var newLevel = 1 + Math.floor(currentTime / 1000 / levelDuration)
        if (newLevel != currentLevel) {
            timeLevelIndicator.setLevel(newLevel)
            createBird()
            currentLevel = newLevel
        }
    }

    function createBird() {
        var newBird = Qt.createQmlObject('Bird {}', mainWindow, "bird")
        birds.push(newBird)
    }

    function onBug1EnabledChanged() {
        if (! BugModel1.enabled) {
            GameData.player1.levelAchieved = currentLevel
            GameData.player1.timeAchieved = currentTime
        }
        checkGameEnd()
    }

    function onBug2EnabledChanged() {
        if (! BugModel2.enabled) {
            GameData.player2.levelAchieved = currentLevel
            GameData.player2.timeAchieved = currentTime
        }
        checkGameEnd()
    }

    function checkGameEnd() {
        if (! BugModel1.enabled && ! BugModel2.enabled) {
            gameStateMachine.signalStopGame()
        }
    }

    // collision detection
    Timer {
        id: collisionDetectionTimer
        interval: 30
        running: false
        repeat: true
        onTriggered: {
            detectAllCollision()
        }
    }

    function detectAllCollision() {
        // bug vs. bug collision
        if (bugs[0].bugModel.enabled && bugs[1].bugModel.enabled) {
            var colliding = Functions.detectCollisionCircleCircle(bug1, bug2)
            bugs[0].bugModel.bugCollision(1, colliding)
            // only one bug needs to know that a collision happened (so only one bug collision sound is played)
            //bugs[1].bugModel.bugCollision(0, colliding)
        }

        // bug vs. bird collision
        for (var bugIndex = 0; bugIndex < bugs.length; bugIndex++) {
            for (var birdIndex = 0; birdIndex < birds.length; birdIndex++) {
                colliding = Functions.detectCollisionCircleCircle(bugs[bugIndex], birds[birdIndex])
                bugs[bugIndex].bugModel.birdCollision(birdIndex, colliding)
            }
        }

        // bug vs. item collision
        for (bugIndex = 0; bugIndex < bugs.length; bugIndex++) {
            if (bugs[bugIndex].bugModel.enabled) {
                for (var itemIndex = 0; itemIndex < collectibleItems.length; itemIndex++) {
                    if (collectibleItems[itemIndex].visible) {
                        colliding = Functions.detectCollisionCircleCircle(bugs[bugIndex], collectibleItems[itemIndex])
                        if (colliding) {
                            var condition
                            var action
                            if (itemIndex === 0) {
                                // itemInvincibility
                                condition = ! bugs[bugIndex].bugModel.invincible
                                action = function func(duration) {bugs[bugIndex].bugModel.startInvincibility(duration * 1000)}
                            } else if (itemIndex === 1) {
                                // itemExtraLife
                                condition = bugs[bugIndex].bugModel.lives !== bugs[bugIndex].bugModel.maxLives
                                action = function func() {bugs[bugIndex].bugModel.updateLives(1)}
                            } else if (itemIndex === 2) {
                               // itemSpeed
                               condition = true
                               action = function func(speed) {bugs[bugIndex].bugModel.setSpeed(speed)}
                            }
                            collectibleItems[itemIndex].hit(condition, action)
                        }
                    }
                }
            }
        }
    }
}
