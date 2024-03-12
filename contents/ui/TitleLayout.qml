
import QtQuick
import QtQml.Models
import QtQuick.Layouts
import QtQuick.Controls
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

GridLayout{
    id: titleLayout
    rows    : plasmoid.formFactor === PlasmaCore.Types.Horizontal ?  1 : -1
    columns : plasmoid.formFactor === PlasmaCore.Types.Horizontal ? -1 :  1
    columnSpacing : 0
    rowSpacing    : 0

    property bool isUsedForMetrics        : false
    property bool exceedsAvailableSpace   : false
    property bool exceedsApplicationText  : false

    property int applicationTextLength: {
        var applicationLength = 0;
        var midSpacerLength = midSpacer.visible ? (plasmoid.formFactor === PlasmaCore.Types.Horizontal ? midSpacer.width : midSpacer.height) : 0;

        if(root.isApplicationStyle || root.isApplicationTitleStyle) applicationLength = firstTxt.implicitWidth;
        else if (root.isTitleApplicationStyle)                      applicationLength =  lastTxt.implicitWidth + midSpacerLength;

        var iconLength = mainIcon.visible ? (plasmoid.formFactor === PlasmaCore.Types.Horizontal ? mainIcon.width : mainIcon.height) : 0;
        var subElements = plasmoid.formFactor === PlasmaCore.Types.Horizontal ?
                    firstSpacer.width  + iconLength + midSpacerLength + lastSpacer.width
                  : firstSpacer.height + iconLength + midSpacerLength + lastSpacer.height;
        return subElements + applicationLength;
    }

    Item{
        id: firstSpacer
        Layout.minimumWidth   : plasmoid.formFactor === PlasmaCore.Types.Horizontal ? plasmoid.configuration.lengthFirstMargin : -1
        Layout.minimumHeight  : plasmoid.formFactor !== PlasmaCore.Types.Horizontal ? plasmoid.configuration.lengthFirstMargin : -1

        Layout.preferredWidth : Layout.minimumWidth
        Layout.preferredHeight: Layout.minimumHeight

        Layout.maximumWidth   : Layout.minimumWidth
        Layout.maximumHeight  : Layout.minimumHeight
    }
    Item {
        id: mainIcon
        Layout.minimumWidth   : plasmoid.formFactor === PlasmaCore.Types.Horizontal ? iconItem.iconSize : root.thickness
        Layout.minimumHeight  : plasmoid.formFactor !== PlasmaCore.Types.Horizontal ? iconItem.iconSize : root.thickness
        Layout.maximumWidth   : Layout.minimumWidth
        Layout.maximumHeight  : Layout.minimumHeight
        visible               : plasmoid.configuration.showIcon && (existsWindowActive || Plasmoid.configuration.placeHolderIcon !== "")

        Kirigami.Icon {
            id: iconItem
            anchors {
                fill         : parent
                topMargin    : plasmoid.formFactor === PlasmaCore.Types.Horizontal ? thickMargin : 0
                bottomMargin : plasmoid.formFactor === PlasmaCore.Types.Horizontal ? thickMargin : 0
                leftMargin   : plasmoid.formFactor === PlasmaCore.Types.Vertical   ? thickMargin : 0
                rightMargin  : plasmoid.formFactor === PlasmaCore.Types.Vertical   ? thickMargin : 0
            }
            source: {
                if( existsWindowActive )                          return activeTaskItem.icon;
                else if( Plasmoid.configuration.useActivityIcon ) return fullActivityInfo.icon;
                else                                              return Plasmoid.configuration.placeHolderIcon;
            }
            readonly property int thickMargin: plasmoid.configuration.iconFillThickness ? 0 : (root.thickness - iconSize) / 2
            readonly property int iconSize   : plasmoid.configuration.iconFillThickness ? root.thickness : Math.min(root.thickness, plasmoid.configuration.iconSize)
        }
    }
    Item{
        id: midSpacer
        Layout.minimumWidth : plasmoid.formFactor === PlasmaCore.Types.Horizontal ? plasmoid.configuration.spacing : -1
        Layout.minimumHeight: plasmoid.formFactor !== PlasmaCore.Types.Horizontal ? plasmoid.configuration.spacing : -1

        Layout.preferredWidth : Layout.minimumWidth
        Layout.preferredHeight: Layout.minimumHeight

<<<<<<< Updated upstream
        visible: mainIcon.visible && (firstTxt.visible || lastTxt.visible) && plasmoid.configuration.style !== 4 /*NoText*/
=======
        Layout.maximumHeight  : Layout.minimumHeight
        Layout.maximumWidth   : Layout.minimumWidth

        visible               : mainIcon.visible && && (firstTxt.visible || lastTxt.visible) && !root.isNoTextStyle
>>>>>>> Stashed changes
    }
    Item{
        id: textsContainer
        Layout.minimumWidth   : plasmoid.formFactor === PlasmaCore.Types.Horizontal ? -1 : root.thickness
        Layout.minimumHeight  : plasmoid.formFactor !== PlasmaCore.Types.Horizontal ? -1 : root.thickness

        Layout.preferredWidth : plasmoid.formFactor === PlasmaCore.Types.Horizontal ? textRow.availableSpace : root.thickness
        Layout.preferredHeight: plasmoid.formFactor !== PlasmaCore.Types.Horizontal ? textRow.availableSpace : root.thickness

        Layout.maximumWidth   : plasmoid.formFactor === PlasmaCore.Types.Horizontal ? textRow.availableSpace : root.thickness
        Layout.maximumHeight  : plasmoid.formFactor !== PlasmaCore.Types.Horizontal ? textRow.availableSpace : root.thickness
        visible               : !root.isNoTextStyle

        RowLayout {
            id      : textRow
            anchors.centerIn: parent
            spacing : 0

            width   : plasmoid.formFactor === PlasmaCore.Types.Horizontal ? parent.width  : parent.height
            height  : plasmoid.formFactor === PlasmaCore.Types.Horizontal ? parent.height : parent.width
            transformOrigin: Item.Center
            rotation: {
                if      (plasmoid.formFactor === PlasmaCore.Types.Horizontal)     return   0;
                else if (plasmoid.location === PlasmaCore.Types.LeftEdge)         return -90;
                else if (plasmoid.location === PlasmaCore.Types.RightEdge)        return  90;
                else                                                              return   0;
            }

            readonly property int implicitWidths:  Math.ceil(firstTxt.implicitWidth) + Math.ceil(midTxt.implicitWidth) + Math.ceil(lastTxt.implicitWidth);
            readonly property int availableSpace: {
                if (!titleLayout.isUsedForMetrics) {
                    if (plasmoid.formFactor === PlasmaCore.Types.Horizontal) {
                        var iconL = mainIcon.visible  ? mainIcon.width   : 0;
                        var midL  = midSpacer.visible ? midSpacer.width  : 0;
                        return titleLayout.width - firstSpacer.width - iconL - midL - lastSpacer.width;
                    } else {
                        var iconL = mainIcon.visible  ? mainIcon.height  : 0;
                        var midL  = midSpacer.visible ? midSpacer.height : 0;
                        return titleLayout.height - firstSpacer.height - iconL - midL - lastSpacer.height;
                }}
                return implicitWidths;
            }

            Label{
                id                      : firstTxt
                Layout.fillWidth        : elide === Text.ElideNone ? false : true
                width                   : Text.ElideNone ? implicitWidth : -1
                verticalAlignment       : Text.AlignVCenter
                text                    : existsWindowActive ? root.firstTitleText : root.fallBackText
                color                   : PlasmaCore.Theme.textColor
                font {
                    capitalization      : plasmoid.configuration.capitalFont ? Font.Capitalize : Font.MixedCase
                    bold                : plasmoid.configuration.boldFont
                    italic              : plasmoid.configuration.italicFont
                }
                visible                 : !isUsedForMetrics && (!showsTitleText || !exceedsApplicationText)

                readonly property bool showsTitleText      : root.isTitleStyle       || root.isTitleApplicationStyle
                readonly property bool showsApplicationText: root.isApplicationStyle || root.isApplicationTitleStyle

                elide: {
                    // return Text.ElideRight
                    if (root.isTitleStyle && titleLayout.exceedsAvailableSpace)                   return plasmoid.configuration.elideMiddle ? Text.ElideMiddle : Text.ElideRight;
                    else if (root.isTitleApplicationStyle
                               && activeTaskItem
                               && activeTaskItem.appName !== activeTaskItem.title
<<<<<<< Updated upstream
                               && titleLayout.exceedsAvailableSpace){ /*TitleApplication*/
                        return Text.ElideMiddle;
                    } else if (showsApplicationText && !isUsedForMetrics && exceedsApplicationText) {
                        return Text.ElideMiddle;
                    }

                    return Text.ElideNone;
                }

                visible: text !== "" && !(!isUsedForMetrics && showsTitleText && exceedsApplicationText)
=======
                               && titleLayout.exceedsAvailableSpace)
                                                                                                  return plasmoid.configuration.elideMiddle ? Text.ElideMiddle : Text.ElideRight;
                    else if (showsApplicationText && !isUsedForMetrics && exceedsApplicationText) return plasmoid.configuration.elideMiddle ? Text.ElideMiddle : Text.ElideRight;
                    else                                                                          return Text.ElideNone;
                }
>>>>>>> Stashed changes
            }

            Label{
                id                 : midTxt
                verticalAlignment  : firstTxt.verticalAlignment
                width              : implicitWidth
                visible            : !exceedsApplicationText && text !== ""
                color              : firstTxt.color
                font               : firstTxt.font
                text: {
                    if (!existsWindowActive) return "";
                    else if ((root.isApplicationTitleStyle || root.isTitleApplicationStyle)
                            && activeTaskItem.appName !== activeTaskItem.title
                            && activeTaskItem.appName !== ""
                            && activeTaskItem.title   !== "")
                        return " – ";
                    else  return "";
                }
            }

            Label{
                id                 : lastTxt
                Layout.fillWidth   : elide === Text.ElideNone ? false : true
                width              : Text.ElideNone ? implicitWidth : -1
                verticalAlignment  : firstTxt.verticalAlignment
                text               : existsWindowActive ? root.lastTitleText : ""
                color              : firstTxt.color
                visible            : text !== "" && !(showsTitleText && exceedsApplicationText)
                font               : firstTxt.font
                readonly property bool showsTitleText: root.isApplicationTitleStyle
                elide: {
                    if (activeTaskItem
                            && activeTaskItem.appName !== activeTaskItem.title
                            && root.isApplicationTitleStyle
                            && titleLayout.exceedsAvailableSpace)
                                                                      return plasmoid.configuration.elideMiddle ? Text.ElideMiddle : Text.ElideRight;
                    else if(root.isTitleApplicationStyle)             return Text.ElideNone;
                    else                                              return plasmoid.configuration.elideMiddle ? Text.ElideMiddle : Text.ElideRight;
                }
            }
        }
    }
    Item {
        id: lastSpacer
        Layout.minimumWidth   : plasmoid.formFactor === PlasmaCore.Types.Horizontal ? plasmoid.configuration.lengthLastMargin : -1
        Layout.minimumHeight  : plasmoid.formFactor !== PlasmaCore.Types.Horizontal ? plasmoid.configuration.lengthLastMargin : -1

        Layout.preferredWidth : Layout.minimumWidth
        Layout.preferredHeight: Layout.minimumHeight

        Layout.maximumWidth   : Layout.minimumWidth
        Layout.maximumHeight  : Layout.minimumHeight
    }
}


