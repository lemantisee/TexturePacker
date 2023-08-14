import QtQuick 2.12
import QtQuick.Controls 2.12

Item {

    id: root
    signal imageOpened(url filepath)
    property url userFileUrl: ""

    function openImage(fileUrl) {
        userFileUrl = fileUrl
        userImage.source = "image://base/" + imageFilepath.toFilePath(fileUrl)
        backgroundImageArea.visible = false
        loadImageBusyBar.visible = true
        loadImageBusyBar.running = true
    }

    Rectangle {
        anchors.fill: parent
        id: backgroundImageArea
        color: "transparent"
        border.color: "#989898"
        border.width: 3

        Image {
            id: backgroundImage
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            source: "/resources/DropImageIcon.png"
            width: 460
            height: 332
        }

    }

    Image {
        id: userImage
        anchors.fill: parent
        asynchronous: true
        visible: false
        fillMode: Image.PreserveAspectFit
        onStatusChanged: function() {
            if (userImage.status == Image.Ready) {
                userImage.visible = true
                loadImageBusyBar.visible = false
                loadImageBusyBar.running = false
                root.imageOpened(userFileUrl)
            }

            if (userImage.status == Image.Error) {
                userImage.visible = false
                loadImageBusyBar.visible = false
                loadImageBusyBar.running = false
                backgroundImageArea.visible = true
            }
        }
    }

    BusyBar {
        id: loadImageBusyBar
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        running: false
        visible: false
        implicitWidth: 32
        implicitHeight: 32
    }

    DropArea {
        id: fileDrop
        anchors.fill: parent
        onDropped: function(drop) {
            if (drop.hasUrls) {
                root.openImage(drop.urls[0])
            }
        }
    }
}
