import QtQuick 2.0

Rectangle {
    id: root
    color: "#4c4c4c"
    radius: 4

    implicitWidth: 90
    implicitHeight: 25

    property alias text: label.text
    signal clicked()

    Text {
        id: label
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#989898"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: function() {
            root.color = "#404040"
        }

        onExited: function() {
            root.color = "#4c4c4c"
        }

        onPressed: function() {
            label.color = "#0091ea"
            root.color = "#212121"
        }

        onReleased: function() {
            label.color = "#989898"
            root.color = "#4c4c4c"
        }

        onClicked: root.clicked()
    }
}
