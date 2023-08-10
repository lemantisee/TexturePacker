import QtCore
import QtQuick.Window
import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Dialogs
import QtQuick.Layouts

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
                opacity: 0.7
                visible: false

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
        }
    }

    FileDialog {
        id: openFileDialog
        fileMode: FileDialog.OpenFile
        onAccepted: {
            image.openImage(selectedFile)
            imageName.text = selectedFile
        }
    }

    FileDialog {
        id: saveFileDialog
        fileMode: FileDialog.SaveFile
        defaultSuffix: "dds"
        nameFilters: ["DDS file (*.dds)"]
        onAccepted: {
            var filepath = selectedFile.toString()
            filepath = filepath.replace('file:///', '')
            compressStatusBar.visible = true;
            textureCompressor.startCompress(imageName.text, filepath)
        }
    }

    Connections {
        target: textureCompressor
        function onError(error) {
            compressStatusBar.visible = false;
        }

        function onFinished() {
            console.log("Compressed")
            compressStatusBar.visible = false;
        }
    }
}
