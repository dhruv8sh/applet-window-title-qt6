import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts

Controls.ComboBox{
    id: combobox
    Layout.minimumWidth: 270
    Layout.preferredWidth: 350
    Layout.maximumWidth:  0.3 * root.width

    model: choices

    property var choices: []

    signal choiceClicked(int index);

    Connections{
        target: popup
        function onClosed() {
            root.forceActiveFocus();
        }
    }

    delegate: MouseArea{
        width: combobox.width
        height: combobox.height
        hoverEnabled: true

        onClicked: {
            combobox.currentIndex = index;
            combobox.choiceClicked(index);
            combobox.popup.close();
        }

        Rectangle{
            id:delegateBackground
            anchors.fill: parent
            color: {
                if (containsMouse) {
                    return palette.highlight;
                }
                if (combobox.currentIndex === index) {
                    return selectedColor;
                }

                return "transparent";
            }

            readonly property color selectedColor: Qt.rgba(palette.highlight.r, palette.highlight.g, palette.highlight.b, 0.5);

            Text{
                id: label
                anchors.left: parent.left
                anchors.leftMargin: units.smallSpacing
                anchors.verticalCenter: parent.verticalCenter
                text: choices[index];
                color: containsMouse ? palette.highlightedText : palette.text
            }
        }
    }
}

