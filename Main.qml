import QtQuick.Window
import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts
import FileDialogItem 1.0
import Compressor 1.0

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
        anchors.topMargin: 5
        anchors.bottomMargin: 5

        FileToolbar {
            id: fileToobar

            Layout.fillWidth: true

            onOpened: function(fileUrl) {
                image.openImage(fileUrl)
            }
        }

        CompressionToolbar {
            id: compressionToolbar
            compressor: textureCompressor
            Layout.fillWidth: true
        }

        ImagePreview {
            id: image
            Layout.fillHeight: true
            Layout.fillWidth: true
            onImageOpened: function(fileUrl) {
                compressionToolbar.setSourceFileUrl(fileUrl)
                statusMessage.hide()
            }

            StatusMessage {
                id: statusMessage
                anchors.topMargin: 5
                anchors.leftMargin: 5
                anchors.top: image.top
                anchors.left: image.left
            }
        }
    }

    Compressor {
        id: textureCompressor
        onStarted: function() {
            statusMessage.showCompressing()
        }

        onFinished: function() {
            statusMessage.showComplete()
        }

        onError: function(error) {
            statusMessage.hide()
        }
    }
}
