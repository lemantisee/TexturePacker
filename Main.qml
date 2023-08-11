import QtQuick.Window
import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts
import FileDialogItem 1.0

Window {
    width: 640
    height: 480
    visible: true
    color: "#343434"
    title: qsTr("Texture Packer")

    ColumnLayout
    {
        id: mainLayout
        anchors.fill: parent
        anchors.rightMargin: 5
        anchors.leftMargin: 5
        anchors.bottomMargin: 5

        RowLayout {
            id: toolBarLayout
            spacing: 6

            Layout.fillWidth: true
            Layout.leftMargin: 5
            Layout.topMargin: 5

            FlatButton {
                id: openFileButton
                text: qsTr("Open image")
                onClicked: openFileDialog.open()
            }

            FlatButton {
                id: compressImageButton
                text: qsTr("Compress")
                onClicked: saveFileDialog.open()
            }

            Label {
                id: imageName
                text: ""
                color: "#989898"
            }
        }

        ImagePreview {
            id: image
            Layout.fillHeight: true
            Layout.fillWidth: true
            onImageOpened: function(filepath) {
                imageName.text = filepath
                compressStatusBar.visible = false;
                compressCompleteBar.visible = false
            }

            Rectangle {
                id: compressStatusBar
                anchors.topMargin: 5
                anchors.leftMargin: 5
                anchors.top: image.top
                anchors.left: image.left

                width: 130
                height: 30
                radius: 5
                color: "#464646"
                opacity: visible ? 0.7 : 0.0
                visible: false

                Behavior on opacity { PropertyAnimation { duration: 300 } }

                function show() {
                    visible = true;
                    showTimer.stop();
                    showTimer.start();
                }

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
                anchors.top: image.top
                anchors.left: image.left

                width: 105
                height: 30
                radius: 5
                color: "#464646"
                opacity: showTimer.running ? 0.7 : 0.0
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
    }

    FileDialogItem {
        id: openFileDialog
        onAccepted: {
            image.openImage(fileUrl)
        }
    }

    FileDialogItem {
        id: saveFileDialog
        dialogType: FileDialogItem.SaveDialog
        filename: imageFilepath.getSaveFilename(imageName.text, "dds")
        nameFilters: ["DDS file (*.dds)"]
        onAccepted: {
            var filepath = imageFilepath.toFilePath(fileUrl)
            compressStatusBar.show()
            compressCompleteBar.visible = false
            textureCompressor.startCompress(imageName.text, imageFilepath.toFilePath(fileUrl))
        }
    }

    Connections {
        target: textureCompressor
        function onError(error) {
            compressStatusBar.visible = false;
            compressCompleteBar.visible = false
        }

        function onFinished() {
            console.log("Compressed")
            compressStatusBar.visible = false;
            compressCompleteBar.show()
        }
    }
}
