import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 2.15

ApplicationWindow {
    id: root
    title: qsTr("Ciphers")
    minimumWidth: 320
    minimumHeight: 300
    visible: true
    color: "transparent"
    flags: Qt.FramelessWindowHint

    Rectangle {
        radius: 5
        anchors.fill: parent
    }


    MouseArea {
        id: resizeWindow
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton

        property int edges: 0;
        property int edgeOffest: 5;

        function setEdges(x, y) {
            edges = 0;
            if (x < edgeOffest) edges |= Qt.LeftEdge;
            if (x > (width - edgeOffest))  edges |= Qt.RightEdge;
            if (y < edgeOffest) edges |= Qt.TopEdge;
            if (y > (height - edgeOffest)) edges |= Qt.BottomEdge;
        }

        cursorShape: {
            return !(containsMouse) ? Qt.ArrowCursor:
                    (edges == 3 || edges == 12) ? Qt.SizeFDiagCursor :
                    (edges == 5 || edges == 10) ? Qt.SizeBDiagCursor :
                    (edges & 9) ? Qt.SizeVerCursor :
                    (edges & 6) ? Qt.SizeHorCursor : Qt.ArrowCursor;
        }

        onPositionChanged: setEdges(mouseX, mouseY);
        onPressed: {
            setEdges(mouseX, mouseY);
            if (edges && containsMouse) startSystemResize(edges);
        }
    }


    ToolBar {
        id: toolBar
        width: root.width
        z: 1
        
        MouseArea {
            anchors.fill: parent

            DragHandler {
                onActiveChanged: if (active) root.startSystemMove()
            }

            onDoubleClicked: {
                if (root.visibility === Window.Maximized)
                    root.visibility = Window.Windowed
                else root.visibility = Window.Maximized
            }
        }
        

        RowLayout {
            anchors.fill: parent

            ToolButton {
                Layout.alignment: Qt.AlignLeft

                text: qsTr("<b>Menu</b>")
                onClicked: {
                    if (sideBar.opened) {
                        sideBar.close();
                    } else {
                        sideBar.open();
                    }
                }
            }

            Label {
                id: toolBarLabel
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

                text: "<b>Ciphers</b>"
            }

            RowLayout {
                Layout.alignment: Qt.AlignRight

                // TODO add images to buttons
                ToolButton {
                    id: minimizeWindow
                    text: qsTr("<b>-</b>")
                    onClicked: root.visibility = Window.Minimized
                }

                ToolButton {
                    id: maximizeWindow
                    text: qsTr("<b>O</b>")
                    onClicked: {
                        if (root.visibility === Window.Maximized)
                            root.visibility = Window.Windowed
                        else root.visibility = Window.Maximized
                    }
                }

                ToolButton {
                    id: closeWindow
                    text: qsTr("<b>X</b>")
                    onClicked: Qt.quit()
                }
            }
        }
    }


    Drawer {
        id: sideBar
        y: toolBar.height
        width: Math.max(150, root.width / 5)
        height: root.height - toolBar.height

        ListModel {
            id: model

            ListElement {
                cipher: "Caesar Shift"
                file: "CaesarShift.qml"
            }

            ListElement {
                cipher: "Vigenère Cipher"
                file: "VigenereCipher.qml"
            }
        }

        ListView {
            id: cipherList
            anchors.fill: parent
            model: model
            focus: true
            
            delegate: Component {
                Item {
                    width: parent.width
                    height: 50
                    
                    Text {
                        x: 15
                        y: this.height / 2
                        text: cipher
                        font.pixelSize: this.height
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            cipherList.currentIndex = index
                            loadScene.source = file;
                        }
                    }
                }
            }

            highlight: Rectangle {
                color: "lightgray"
                radius: 5
                
                Text {
                    anchors.right: parent.right
                    text: "Select"
                    color: "red"
                }
            }
        }
    }

    Loader {
        id: loadScene
        anchors.top: toolBar.bottom
        x: root.width / 2
    }
}
