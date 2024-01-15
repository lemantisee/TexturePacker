import QtQuick 2.12

Item {

    id: root
    function showCompressing() {
        compressCompleteBar.visible = false
        compressStatusBar.visible = true
    }

    function showComplete() {
        compressStatusBar.visible = false
        compressCompleteBar.show()
    }

    function hide() {
        compressCompleteBar.visible = false
        compressStatusBar.visible = false
    }

    readonly property real barOpacity: 0.9

    Rectangle {
        id: compressStatusBar
        anchors.topMargin: 5
        anchors.leftMargin: 5
        anchors.top: parent.top
        anchors.left: parent.left

        width: 130
        height: 30
        radius: 5
        color: "#464646"
        opacity: visible ? barOpacity : 0.0
        visible: false

        Behavior on opacity { PropertyAnimation { duration: 300 } }

        BusyBar {
            id: compressBusyBar
            anchors.leftMargin: 5
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            running: true
            implicitWidth: 26
            implicitHeight: 26
        }

        Text {
            id: compressLabel
            text: qsTr("Compressing...")
            anchors.leftMargin: 5 + compressBusyBar.width + 5
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            color: "#989898"
        }
    }

    Rectangle {
        id: compressCompleteBar
        anchors.topMargin: 5
        anchors.leftMargin: 5
        anchors.top: parent.top
        anchors.left: parent.left

        width: 105
        height: 30
        radius: 5
        color: "#464646"
        opacity: showTimer.running ? barOpacity : 0.0
        visible: false

        function show() {
            visible = true;
            showTimer.stop();
            showTimer.start();
        }

        Behavior on opacity { PropertyAnimation { duration: 300 } }

        Image {
            id: doneLogo
            anchors.leftMargin: 5
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            source: "/resources/done.png"
            width: 19
            height: 15
        }

        Text {
            id: completeLabel
            text: qsTr("Compressed")
            anchors.leftMargin: 5 + doneLogo.width + 3
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            color: "#989898"
        }

        Timer {
            id: showTimer
            interval: 3000
        }
    }
}
