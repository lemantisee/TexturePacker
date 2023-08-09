import QtQuick
import QtQuick.Window
import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Dialogs
import QtQuick.Layouts

Window {
    width: 640
    height: 480
    visible: true
    color: "#3b3b3b"
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

            Button {
                id: openFileButton
                text: qsTr("Open image")
                onClicked: fileDialog.open()
                flat: true
                onHoveredChanged: {
                    buttonRect.color = openFileButton.hovered ? "#2b2b2b" : "#343434"
                }
                onPressed: {
                    buttonRect.color = "#343434"
                }

                onReleased: {
                    buttonRect.color = "#343434"
                }

                background: Rectangle {
                    id: buttonRect
                    color: "#343434"
                    radius: 4
                }

                contentItem: Text {
                        text: openFileButton.text
                        font: openFileButton.font
                        color: openFileButton.pressed ? "#0091ea" : "#989898"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }
            }

            Label {
                id: imageName
                text: ""
                color: "#989898"
            }
        }

        Image {
            id: image
            asynchronous: true
            fillMode: Image.PreserveAspectFit
            source: "/resources/DropImageIcon.png"

            Layout.fillHeight: true
            Layout.fillWidth: true

            DropArea {
                id: fileDrop
                anchors.fill: parent
                onDropped: function(drop) {
                    if(drop.hasUrls) {
                        image.source = "image://base/" + drop.urls[0]
                        imageName.text = drop.urls[0]
                    }
                }
            }
        }

    }


    FileDialog {
        id: fileDialog
        currentFolder: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
        onAccepted: {
            image.source = "image://base/" + selectedFile
            imageName.text = selectedFile
        }
    }
}
