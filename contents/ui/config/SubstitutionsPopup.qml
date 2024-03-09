import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

import "../../tools/Tools.js" as Tools

SlidingBox {
    id: popup
    width: Tools.qBound(400, 0.6*page.width, 750)

    property QtObject page: null

    function textAreaToList(text) {
        var res = text.split("\n");
        return res;
    }

    function listToText(text) {
        var res = text.join("\n");
        return res;
    }

    contentItem: ColumnLayout{
        id: mainColumn
        width: popup.availableWidth
        anchors.margins: Kirigami.Units.largeSpacing
        anchors.centerIn: parent
        spacing: Kirigami.Units.largeSpacing

        Label{
            Layout.fillWidth: true
            horizontalAlignment: Qt.AlignHCenter
            font.bold: true
            text: i18n("Substitutions")
        }

        GridLayout {
            columns: 2
            Label{
                Layout.fillWidth: true
                horizontalAlignment: Qt.AlignHCenter
                font.bold: true
                text: "Match"
            }
            Label{
                Layout.fillWidth: true
                horizontalAlignment: Qt.AlignHCenter
                font.bold: true
                text: "Replace with"
            }
            TextArea{
                id: textAreaMatch

                Layout.fillWidth: true
                Layout.fillHeight: true
                text: listToText(page.selectedMatches)

                onTextChanged: page.selectedMatches = popup.textAreaToList(text)

                Flickable {
                  onContentYChanged: textAreaReplace.flickableItem.contentY = flickableItem.contentY
                }
            }
            TextArea{
                id: textAreaReplace

                Layout.fillWidth: true
                Layout.fillHeight: true
                text: listToText(page.selectedReplacements)
                onTextChanged: page.selectedReplacements = popup.textAreaToList(text)

                Flickable {
                  onContentYChanged: textAreaMatch.flickableItem.contentY = flickableItem.contentY
                }
            }
        }

        Label{
            Layout.fillWidth: true
            horizontalAlignment: Qt.AlignHCenter
            text: i18n("%a for Application Name, %w for window title")
        }

        Label{
            Layout.fillWidth: true
            horizontalAlignment: Qt.AlignHCenter
            font.italic: true
            color: "#ff0000"
            text: page.selectedMatches.length !== page.selectedReplacements.length ? i18n("Warning: Matches and Replacements do not have the same size...") : "";
        }
    }
}
