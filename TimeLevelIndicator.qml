import QtQuick 2.15
import QtMultimedia 5.15
import QtQuick.Shapes 1.15
import QtQuick.Layouts 1.15

Item {
    id: timeLevelIndicator
    height: parent.height - 10
    width: 300

    signal setLevel(level: int)
    signal setTime(time: string)

    onSetLevel: function(level) {
        levelText.text = "Level: " + level
    }

    onSetTime: function(time) {
        timeText.text = time
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "tan"
        radius: 10
        border.width: 3
        border.color: "peru"
    }

    Text {
        id: levelText
        x: 25
        y: 3
        font.pointSize: 18
        font.family: "Courier"
        text: "Level:"
    }

    Text {
        id: timeText
        x: 195
        y: 3
        font.pointSize: 18
        font.family: "Courier"
        text: "00:00"
    }
}
