pragma Singleton

import QtQuick 2.15

QtObject {
    readonly property color lightTextColor: "white"
    readonly property color darkTextColor: "black"
    readonly property color highlightTextColor: "red"
    readonly property string mainFont: "Tomson Talks"
    readonly property int headline1FontSize: 75
    readonly property int headline2FontSize: 35
    readonly property int textFontSize: 30
    readonly property int smallTextFontSize: 22

    readonly property string countdownFont: "Ubuntu"
    readonly property int countdownFontSize: 200

    readonly property color overlayBackgroundColor: "tan"
    readonly property color overlayBorderColor: "peru"
    readonly property int overlayBorderWidth: 3
}
