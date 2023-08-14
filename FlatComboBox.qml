import QtQuick 2.12
import QtQuick.Controls 2.12

ComboBox {
    id: root

    delegate: ItemDelegate {
        id: itemDelegate
        width: root.width
        implicitHeight: 23
        contentItem: Text {
            text: modelData
            color: "#989898"
            font: root.font
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }

        background: Rectangle {
            id: itemDelegateBack
            width: itemDelegate.width - 2 * itemDelegateBack.border.width
            implicitHeight: itemDelegate.implicitHeight
            color: "#3e3e3e"
            border.color: itemDelegate.highlighted ? "#0091ea" : color
            border.width: 1
        }

        highlighted: root.highlightedIndex === index
    }

    indicator: Canvas {
        id: canvas
        x: root.width - width - root.rightPadding
        y: root.topPadding + (root.availableHeight - height) / 2
        width: 12
        height: 6
        contextType: "2d"

        Connections {
            target: root
            function onDownChanged() { canvas.requestPaint(); }
        }

        onPaint: {
            context.reset();
            context.lineWidth = 2
            context.strokeStyle = root.down ? "#0091ea" : "#989898";

            context.beginPath()
            context.moveTo(canvas.width * 0.05, 0)
            context.lineTo(canvas.width / 2, canvas.height * 0.95)
            context.lineTo(canvas.width * 0.95, 0)
            context.stroke()
        }
    }

    contentItem: Text {
        leftPadding: 0
        rightPadding: root.indicator.width + root.spacing

        text: root.displayText
        font: root.font
        color: root.down ? "#0091ea" : "#989898"
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        color: "#292929"
        radius: 4
        implicitWidth: 120
        implicitHeight: 25
        border.color: "#383838"
        border.width: 1
    }

    popup: Popup {
        y: root.height - 1
        width: root.width
        padding: 1

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: root.popup.visible ? root.delegateModel : null
            currentIndex: root.highlightedIndex

            ScrollIndicator.vertical: ScrollIndicator { }
        }

        background: Rectangle {
            color: "#3e3e3e"
            border.color: "#292929"
            border.width: 1
            radius: 4
        }
    }
}
