import QtQuick 2.15

Rectangle {
    id: root
    
    property color bgColor: "#B0D1D8"
    property color pressedColor: "#04BFAD"
    property color textColor: "#024873"
    
    property int btnSize: 62
    property int textSize: 24
    
    property alias text: label.text
    
    signal clicked()

    width: btnSize
    height: btnSize
    radius: btnSize / 2
    color: mouseArea.pressed ? pressedColor : bgColor

    Text {
        id: label
        anchors.centerIn: parent
        
        font.family: "Open Sans"
        font.weight: Font.DemiBold
        font.pixelSize: root.textSize
        color: mouseArea.pressed ? "#FFFFFF" : root.textColor
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: root.clicked()
    }
}