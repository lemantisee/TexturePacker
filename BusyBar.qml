import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    property alias running: loadImageBusyBar.running

    BusyIndicator {
        id: loadImageBusyBar
        anchors.fill: parent

        contentItem: Item {
            anchors.fill: parent

            Item {
                id: item
                x: parent.width / 2 - parent.width / 2
                y: parent.height / 2 - parent.height / 2
                width: parent.width
                height: parent.height
                opacity: loadImageBusyBar.running ? 1 : 0

                Behavior on opacity {
                    OpacityAnimator {
                        duration: 250
                    }
                }

                RotationAnimator {
                    target: item
                    running: loadImageBusyBar.visible && loadImageBusyBar.running
                    from: 0
                    to: 360
                    loops: Animation.Infinite
                    duration: 1250
                }

                Repeater {
                    id: repeater
                    model: 6

                    Rectangle {
                        x: item.width / 2 - width / 2
                        y: item.height / 2 - height / 2
                        implicitWidth: 4
                        implicitHeight: 4
                        radius: implicitWidth / 2
                        color: "#989898"
                        transform: [
                            Translate {
                                y: -Math.min(item.width, item.height) * 0.5 + 5
                            },
                            Rotation {
                                angle: index / repeater.count * 360
                                origin.x: implicitWidth / 2
                                origin.y: implicitHeight / 2
                            }
                        ]
                    }
                }
            }
        }
    }
}
