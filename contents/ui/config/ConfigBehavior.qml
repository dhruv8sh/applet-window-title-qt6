import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.plasma.components

import org.kde.kirigami as Kirigami

import "../../tools/Tools.js" as Tools

Item {
    id: behaviorPage

    property alias cfg_filterByScreen: filterByScreenChk.checked
    property alias cfg_filterActivityInfo: filterActivityChk.checked

    property alias cfg_showTooltip: showTooltip.checked
    property alias cfg_actionScrollMinimize: cycleMinimizeChk.checked

    property alias cfg_subsMatch: behaviorPage.selectedMatches
    property alias cfg_subsReplace: behaviorPage.selectedReplacements

    property alias cfg_showOnlyOnMaximize: showOnlyOnMaximize.checked
    property alias cfg_placeHolder: placeHolder.text

    // used as bridge to communicate properly between configuration and ui
    property var selectedMatches: []
    property var selectedReplacements: []

    // used from the ui
    readonly property real centerFactor: 0.3
    readonly property int minimumWidth: 220

    ColumnLayout {
        id:mainColumn
        spacing: Kirigami.Units.largeSpacing
        width:parent.width - anchors.leftMargin * 2
        height: parent.height
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 2

        GridLayout {
            columns: 2

            Label{
                Layout.minimumWidth: Math.max(centerFactor * behaviorPage.width, minimumWidth)
                text: i18n("Filters:")
                horizontalAlignment: Label.AlignRight
            }

            CheckBox{
                id: filterByScreenChk
                text: i18n("Show only window information from current screen")
            }
            Label{
                horizontalAlignment: Label.AlignRight
            }
            CheckBox{
                id: showOnlyOnMaximize
                text: i18n("Show only when maximized")
                enabled: true
            }
        }

        GridLayout {
            columns: 2

            Label{
                Layout.minimumWidth: Math.max(centerFactor * behaviorPage.width, minimumWidth)
                text: i18n("Mouse:")
                horizontalAlignment: Label.AlignRight
            }

            CheckBox{
                id: showTooltip
                text: i18n("Show tooltip on hover")
                enabled: true
            }

            Label{
                visible: cycleMinimizeChk.visible
            }

            CheckBox {
                id: cycleMinimizeChk
                text: i18n("Scroll to cycle and minimize through your tasks")
                visible: true
            }
        }


        GridLayout {
            columns: 2
            Label{
                Layout.minimumWidth: Math.max(centerFactor * behaviorPage.width, minimumWidth)
                text: i18n("Placeholder:")
                horizontalAlignment: Label.AlignRight
            }

            CheckBox{
                id: filterActivityChk
                text: i18n("Show activity information")
            }

            Label{}

            TextField {
                id: placeHolder
                text: plasmoid.configuration.placeHolder
                Layout.minimumWidth: substitutionsBtn.width * 1.5
                Layout.maximumWidth: Layout.minimumWidth
                enabled: !filterActivityChk.checked

                placeholderText: i18n("placeholder text...")
            }
        }

        GridLayout{
            columns: 2

            Label{
                Layout.minimumWidth: Math.max(centerFactor * behaviorPage.width, minimumWidth)
                text: i18n("Application name:")
                horizontalAlignment: Label.AlignRight
            }

            Button{
                id: substitutionsBtn
                checkable: true
                checked: subsSlidingBox.shown
                text: "  " + i18n("Manage substitutions...") + "  "
                onClicked: {
                    if (subsSlidingBox.shown) {
                        subsSlidingBox.slideOut();
                    } else {
                        subsSlidingBox.slideIn();
                    }
                }

                SubstitutionsPopup {
                    id: subsSlidingBox
                    page: behaviorPage
                    slideOutFrom: PlasmaCore.Types.BottomEdge
                }
            }
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }

}
