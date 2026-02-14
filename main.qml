import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

ApplicationWindow {
    id: window
    visible: true
    width: 360
    height: 640
    title: qsTr("Calculator")

    // Навигация между экранами: основной калькулятор → секретное меню
    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: Calculator {
            // При разблокировке секрета переходим в секретное меню
            onSecretUnlocked: stackView.push(secretComponent)
        }
    }

    // Предзагруженный компонент секретного меню (оптимизация перехода)
    Component {
        id: secretComponent
        SecretMenu {
            // Ссылка для возврата в основное меню через stackView.pop()
            stackViewRef: stackView
        }
    }
}