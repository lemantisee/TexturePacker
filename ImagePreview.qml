import QtQuick 2.12
import QtQuick.Controls 2.12

Item {

    id: root
    signal imageOpened(url filepath)
    property url userFileUrl: ""

    function openImage(fileUrl) {
        userFileUrl = fileUrl;
        userImage.source = "image://base/" + imageFilepath.toFilePath(fileUrl);
        backgroundImageArea.visible = false;
        chessBackground.visible = true;
        loadImageBusyBar.visible = true;
        loadImageBusyBar.running = true;
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

    Canvas {
        id: chessBackground
        anchors.fill: parent
        contextType: "2d"
        visible: false;

        onPaint: {
            context.reset();

            const cellSize = 12;

            for (var c = 0; c < height / cellSize; ++c) {
                const y = c * cellSize;
                const firstColor = c % 2 == 0 ? "#BFBFBF" : "#FFFFFF";
                const secondColor = c % 2 == 0 ? "#FFFFFF" : "#BFBFBF";
                for(var r = 0; r < width / cellSize; ++r) {
                    const x = r * cellSize;
                    context.fillStyle = r % 2 == 0 ? firstColor : secondColor;
                    context.fillRect(x, y, cellSize, cellSize);
                }
            }

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
                chessBackground.visible = false;
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

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: function(mouse) {
            if (mouse.button === Qt.RightButton) {
                contextMenu.popup();
            }
        }

        Menu {
            id: contextMenu
            background: Rectangle {
                id: contextMenuBackground
                implicitWidth: showTransparentBackgroundItem.width
                color: "#4c4c4c";
            }

            MenuItem {
                id: showTransparentBackgroundItem
                text: chessBackground.visible ? qsTr("Hide transparent background")
                                              : qsTr("Show transparent background")
                onTriggered: function() {
                    chessBackground.visible = !chessBackground.visible
                }
            }
        }
    }
}
