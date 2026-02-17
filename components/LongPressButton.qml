import QtQuick 2.15

Rectangle {
    id: root

    property int longPressDuration: 4000

    property color bgColor: "#0889A6"
    property color pressedColor: "#F7E425"
    property color textColor: "#FFFFFF"

    property int btnSize: 64
    property int textSize: 24

    property alias text: label.text
    property string iconSource: ""

    signal longPressActivated()
    signal regularClick()

    property bool wasLongPress: false

    width: btnSize
    height: btnSize
    radius: btnSize / 2
    color: mouse.pressed ? pressedColor : bgColor

    Image {
        id: icon
        anchors.centerIn: parent
        source: root.iconSource
        width: 32
        height: 32
        fillMode: Image.PreserveAspectFit
        visible: root.iconSource !== ""
    }

    Text {
        id: label
        anchors.centerIn: parent
        visible: root.iconSource === ""

        font.family: "Open Sans"
        font.weight: Font.DemiBold
        font.pixelSize: root.textSize
        color: root.textColor
    }

    Timer {
        id: longPressTimer
        interval: root.longPressDuration
        repeat: false
        onTriggered: {
            if (mouse.pressed) {
                root.wasLongPress = true
                root.longPressActivated()
            }
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent

        onPressed: {
            root.wasLongPress = false
            longPressTimer.start()
        }

        onReleased: {
            longPressTimer.stop()
            if (!root.wasLongPress) {
                root.regularClick()
            }
            root.wasLongPress = false
        }
    }
}