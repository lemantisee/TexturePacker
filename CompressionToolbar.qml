import QtQuick 2.12
import QtQuick.Layouts
import QtQuick.Controls 2.15
import FileDialogItem 1.0
import Compressor 1.0

Item {
    id: root
    implicitHeight: 25

    property url sourceFileUrl
    required property Compressor compressor

    RowLayout {
        id: toolBarLayout
        spacing: 6

        Layout.fillWidth: true

        Label {
            text: qsTr("Compression type:")
            color: "#989898"
        }

        FlatComboBox {
            id: compressionCombo
            model: ["BC4", "BC7"]
        }

        FlatButton {
            id: compressImageButton
            text: qsTr("Compress")
            onClicked: saveFileDialog.open()
        }
    }

    FileDialogItem {
        id: saveFileDialog
        dialogType: FileDialogItem.SaveDialog
        filename: imageFilepath.getSaveFilename(sourceFileUrl, "dds")
        nameFilters: ["DDS file (*.dds)"]
        onAccepted: {

            var type = Compressor.CompressionUnknwon;

            switch(compressionCombo.currentText) {
            case "BC4":
                type = Compressor.CompressionBC4;
                break;
            case "BC7":
                type = Compressor.CompressionBC7;
                break;
            default:
                return;
            }

            compressor.startCompress(imageFilepath.toFilePath(sourceFileUrl),
                                     imageFilepath.toFilePath(fileUrl), type)
        }
    }
}
