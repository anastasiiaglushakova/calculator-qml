import QtQuick 2.15
import QtQuick.Layouts 1.15
import "components"

Item {
    id: calculator
    width: 360
    height: 640

    property string expression: ""
    property string display: "0"
    property bool afterEquals: false

    property bool codeEntryActive: false
    property string codeBuffer: ""
    signal secretUnlocked()

    Timer {
        id: codeTimeoutTimer
        interval: 5000
        repeat: false
        onTriggered: resetCodeEntry()
    }

    function activateCodeEntry() {
        codeEntryActive = true
        codeBuffer = ""
        codeTimeoutTimer.restart()
        console.log(">>> Режим ввода кода активирован (5 сек на ввод '123')")
    }

    function resetCodeEntry() {
        codeEntryActive = false
        codeBuffer = ""
        codeTimeoutTimer.stop()
        console.log(">>> Режим ввода кода завершён (таймаут или неверный код)")
    }

    function processKey(key) {
        if (codeEntryActive) {
            if (key !== "1" && key !== "2" && key !== "3") {
                resetCodeEntry()
                return
            }

            const prevBuffer = codeBuffer
            codeBuffer += key
            console.log("→ Ввод кода: " + codeBuffer)

            if (codeBuffer === "123") {
                codeTimeoutTimer.stop()
                codeEntryActive = false
                codeBuffer = ""
                console.log(">>> Код '123' введён успешно! Открытие секретного меню...")
                secretUnlocked()
                return
            }

            if ((prevBuffer === "" && key !== "1") ||
                (prevBuffer === "1" && key !== "2") ||
                (prevBuffer === "12" && key !== "3") ||
                codeBuffer.length > 3) {
                resetCodeEntry()
                return
            }

            return
        }

        if (key === "C") {
            expression = ""
            display = "0"
            afterEquals = false
            return
        }

        if (afterEquals) {
            if (["0","1","2","3","4","5","6","7","8","9","(","-"].includes(key)) {
                expression = ""
                afterEquals = false
            } else if (["+", "−", "×", "÷"].includes(key)) {
                expression = display + key
                afterEquals = false
                return
            }
        }

        if (key === "()") {
            toggleParenthesis()
            return
        }

        if (key === "+/-") {
            toggleSign()
            return
        }

        if (key === ".") {
            if (hasDecimalInCurrentNumber()) return
        }

        if (["+", "−", "×", "÷"].includes(key) && expression !== "") {
            const lastChar = expression[expression.length - 1]
            if (["+", "−", "×", "÷"].includes(lastChar)) {
                expression = expression.slice(0, -1) + key
                return
            }
        }

        if (["0","1","2","3","4","5","6","7","8","9",".","+","−","×","÷","(",")"].includes(key)) {
            expression += key
        }
    }

    function calc() {
        if (expression === "") return

        try {
            const jsExpr = expression
                .replace(/×/g, "*")
                .replace(/÷/g, "/")
                .replace(/−/g, "-")

            let result = eval(jsExpr)

            if (isNaN(result) || !isFinite(result)) {
                display = "Error"
            } else {
                display = formatResult(result)
            }
            afterEquals = true
        } catch (e) {
            display = "Error"
        }
    }

    function percent() {
        if (expression === "") return

        const match = expression.match(/[\d\.]+$/)
        if (match) {
            const lastNumber = parseFloat(match[0])
            const percentValue = lastNumber / 100
            expression = expression.slice(0, -match[0].length) + percentValue.toString()
        }
    }

    function toggleParenthesis() {
        let openCount = 0
        let closeCount = 0
        for (let i = 0; i < expression.length; i++) {
            if (expression[i] === "(") openCount++
            if (expression[i] === ")") closeCount++
        }

        const lastChar = expression[expression.length - 1] || ""
        const needsClosing = openCount > closeCount && 
                             expression !== "" && 
                             !["+", "−", "×", "÷", "("].includes(lastChar)

        if (needsClosing) {
            expression += ")"
        } else if (expression === "" || ["+", "−", "×", "÷", "("].includes(lastChar)) {
            expression += "("
        } else {
            expression += openCount > closeCount ? ")" : "("
        }
    }

    function toggleSign() {
        if (expression === "") {
            expression = "-"
            return
        }

        const lastOpIndex = Math.max(
            expression.lastIndexOf("+"),
            expression.lastIndexOf("−"),
            expression.lastIndexOf("×"),
            expression.lastIndexOf("÷"),
            expression.lastIndexOf("(")
        )

        if (lastOpIndex === -1) {
            expression = expression.startsWith("-") 
                ? expression.substring(1) 
                : "-" + expression
        } else {
            const prefix = expression.substring(0, lastOpIndex + 1)
            const numberPart = expression.substring(lastOpIndex + 1)
            expression = numberPart.startsWith("-")
                ? prefix + numberPart.substring(1)
                : prefix + "-" + numberPart
        }
    }

    function hasDecimalInCurrentNumber() {
        const parts = expression.split(/[\+\−×÷\(\)]/)
        const lastNumber = parts[parts.length - 1] || ""
        return lastNumber.includes(".")
    }

    function formatResult(value) {
        if (Math.abs(value) >= 1e10) {
            return value.toPrecision(10).replace(/\.?0+$/, "")
        }

        if (value % 1 === 0) {
            return value.toString()
        }

        return parseFloat(value.toFixed(4)).toString()
    }

    Rectangle {
        anchors.fill: parent
        color: "#024873"
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            Layout.preferredHeight: 180
            width: parent.width
            anchors.top: parent.top

            Rectangle {
                width: parent.width
                height: parent.height - 32
                color: "#04BFAD"
                anchors.top: parent.top
            }

            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 64
                radius: 32
                color: "#04BFAD"
            }

            Text {
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    margins: 16
                    topMargin: 50
                }
                text: expression
                font {
                    family: "Open Sans"
                    weight: Font.DemiBold
                    pixelSize: 20
                }
                color: "#FFFFFF"
                horizontalAlignment: Text.AlignRight
                maximumLineCount: 1
                elide: Text.ElideLeft
            }

            Text {
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                    margins: 16
                }
                text: display
                font {
                    family: "Open Sans"
                    weight: Font.DemiBold
                    pixelSize: 50
                }
                color: "#FFFFFF"
                horizontalAlignment: Text.AlignRight
            }
        }

        GridLayout {
            anchors.horizontalCenter: parent.horizontalCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
            rows: 5
            columns: 4
            columnSpacing: 22
            rowSpacing: 22

            KeypadButton { text: "()";  bgColor: "#0889A6"; pressedColor: "#F7E425"; textColor: "#FFFFFF"; onClicked: processKey("()") }
            KeypadButton { text: "+/-"; bgColor: "#0889A6"; pressedColor: "#F7E425"; textColor: "#FFFFFF"; onClicked: processKey("+/-") }
            KeypadButton { text: "%";   bgColor: "#0889A6"; pressedColor: "#F7E425"; textColor: "#FFFFFF"; onClicked: percent() }
            KeypadButton { text: "÷";   bgColor: "#0889A6"; pressedColor: "#F7E425"; textColor: "#FFFFFF"; onClicked: processKey("÷") }

            KeypadButton { text: "7"; bgColor: "#B0D1D8"; pressedColor: "#04BFAD"; textColor: "#024873"; onClicked: processKey("7") }
            KeypadButton { text: "8"; bgColor: "#B0D1D8"; pressedColor: "#04BFAD"; textColor: "#024873"; onClicked: processKey("8") }
            KeypadButton { text: "9"; bgColor: "#B0D1D8"; pressedColor: "#04BFAD"; textColor: "#024873"; onClicked: processKey("9") }
            KeypadButton { text: "×"; bgColor: "#0889A6"; pressedColor: "#F7E425"; textColor: "#FFFFFF"; onClicked: processKey("×") }

            KeypadButton { text: "4"; bgColor: "#B0D1D8"; pressedColor: "#04BFAD"; textColor: "#024873"; onClicked: processKey("4") }
            KeypadButton { text: "5"; bgColor: "#B0D1D8"; pressedColor: "#04BFAD"; textColor: "#024873"; onClicked: processKey("5") }
            KeypadButton { text: "6"; bgColor: "#B0D1D8"; pressedColor: "#04BFAD"; textColor: "#024873"; onClicked: processKey("6") }
            KeypadButton { text: "−"; bgColor: "#0889A6"; pressedColor: "#F7E425"; textColor: "#FFFFFF"; onClicked: processKey("−") }

            KeypadButton { text: "1"; bgColor: "#B0D1D8"; pressedColor: "#04BFAD"; textColor: "#024873"; onClicked: processKey("1") }
            KeypadButton { text: "2"; bgColor: "#B0D1D8"; pressedColor: "#04BFAD"; textColor: "#024873"; onClicked: processKey("2") }
            KeypadButton { text: "3"; bgColor: "#B0D1D8"; pressedColor: "#04BFAD"; textColor: "#024873"; onClicked: processKey("3") }
            KeypadButton { text: "+"; bgColor: "#0889A6"; pressedColor: "#F7E425"; textColor: "#FFFFFF"; onClicked: processKey("+") }

            KeypadButton { text: "C"; bgColor: "#f5a9a2"; pressedColor: "#F25E5E"; textColor: "#FFFFFF"; onClicked: processKey("C") }
            KeypadButton { text: "0"; bgColor: "#B0D1D8"; pressedColor: "#04BFAD"; textColor: "#024873"; onClicked: processKey("0") }
            KeypadButton { text: "."; bgColor: "#B0D1D8"; pressedColor: "#04BFAD"; textColor: "#024873"; onClicked: processKey(".") }
            LongPressButton {
                text: "="
                longPressDuration: 4000
                onLongPressActivated: activateCodeEntry()
                onRegularClick: calc()
            }
        }
    }
}