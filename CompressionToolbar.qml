import QtQuick 2.12
import QtQuick.Layouts
import QtQuick.Controls 2.15
import FileDialogItem 1.0
import Compressor 1.0

Item {
    id: root
    implicitHeight: toolBarLayout.height

    property string saveFilepath
    property url sourceFileUrl
    required property Compressor compressor

    readonly property string bc4Label: "BC4 (greyscale)"
    readonly property string bc7Label: "BC7 (RGB, RGBA)"

    readonly property string noneLabel: "None"
    readonly property string boxLabel: "Box"
    readonly property string triangleLabel: "Triangle"
    readonly property string kaiserLabel: "Kaiser"

    function setSourceFileUrl(url) {
        sourceFileUrl = url
        saveFilepath = imageFilepath.getParentPath(url) + "/"
                + imageFilepath.getSaveFilename(url, "dds")
    }

    function getCompressionType() {

        switch(compressionCombo.currentText) {
        case bc4Label:
            return Compressor.CompressionBC4;
        case bc7Label:
            return Compressor.CompressionBC7;
        default:
            break;
        }

        return Compressor.CompressionUnknwon;
    }

    function getMipmapType() {

        switch(mipmapCombo.currentText) {
        case boxLabel:
            return Compressor.MipmapBox;
        case triangleLabel:
            return Compressor.MipmapTriangle;
        case kaiserLabel:
            return Compressor.MipmapKaiser;
        case noneLabel:
        default:
            break;
        }

        return Compressor.MipmapNone;
    }

    GridLayout {
        id: toolBarLayout
        columns: 2
        Layout.fillWidth: true

        Label {
            text: qsTr("Compression type:")
            color: "#989898"
        }

        FlatComboBox {
            id: compressionCombo
            model: [bc4Label, bc7Label]
        }

        Label {
            text: qsTr("Mipmap type:")
            color: "#989898"
        }

        FlatComboBox {
            id: mipmapCombo
            model: [noneLabel, boxLabel, triangleLabel, kaiserLabel]
        }

        FlatButton {
            id: compressImageButton
            text: qsTr("Compress")
            onClicked: saveFileDialog.open(saveFilepath)
        }
    }

    FileDialogItem {
        id: saveFileDialog
        dialogType: FileDialogItem.SaveDialog
        nameFilters: ["DDS file (*.dds)"]
        onAccepted: {

            var compressionType = getCompressionType();
            if (compressionType === Compressor.CompressionUnknwon) {
                return;
            }

            compressor.startCompress(imageFilepath.toFilePath(sourceFileUrl),
                                     imageFilepath.toFilePath(fileUrl),
                                     compressionType, getMipmapType())
        }
    }
}
