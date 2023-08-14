import QtQuick 2.12
import QtQuick.Layouts
import QtQuick.Controls 2.15
import FileDialogItem 1.0

Item {
    id: root
    implicitHeight: 25

    signal opened(url fileUrl)

    RowLayout {
        id: toolBarLayout
        spacing: 6

        FlatButton {
            id: openFileButton
            text: qsTr("Open image")
            onClicked: openFileDialog.open()
        }

        Label {
            id: imageName
            text: ""
            color: "#989898"
        }
    }

    FileDialogItem {
        id: openFileDialog
        onAccepted: {
            imageName.text = imageFilepath.toFilePath(fileUrl)
            root.opened(fileUrl)
        }
    }
}
