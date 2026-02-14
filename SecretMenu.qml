import QtQuick 2.15
import QtQuick.Layouts 1.15

Item {
    id: secretMenu
    property var stackViewRef: null

    readonly property color bgColor: "#024873"
    readonly property color panelColor: "#04BFAD"
    readonly property color buttonColor: "#0889A6"
    readonly property color buttonPressedColor: "#F7E425"
    readonly property color textColor: "#FFFFFF"

    Rectangle {
        anchors.fill: parent
        color: secretMenu.bgColor
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 30

        Rectangle {
            width: 280
            height: 120
            color: secretMenu.panelColor
            radius: 16

            Text {
                anchors.centerIn: parent
                text: qsTr("Секретное меню")
                font {
                    family: "Open Sans"
                    weight: Font.DemiBold
                    pixelSize: 24
                }
                color: secretMenu.textColor
            }
        }

        Rectangle {
            id: backButton
            width: 280
            height: 60
            color: mouseArea.pressed ? secretMenu.buttonPressedColor : secretMenu.buttonColor
            radius: 16

            Text {
                anchors.centerIn: parent
                text: qsTr("Назад")
                font {
                    family: "Open Sans"
                    weight: Font.DemiBold
                    pixelSize: 24
                }
                color: secretMenu.textColor
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                onClicked: {
                    if (secretMenu.stackViewRef && secretMenu.stackViewRef.depth > 1) {
                        secretMenu.stackViewRef.pop()
                    } else {
                        console.warn("StackView недоступен или находится на корневом экране")
                    }
                }
            }
        }
    }
}