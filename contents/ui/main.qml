import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.taskmanager       as TaskManager
import org.kde.kirigami          as Kirigami
import org.kde.activities        as Activities
import "../tools/Tools.js"       as Tools

PlasmoidItem {
    id: root
    clip: true

    Layout.fillWidth:   (inFillLengthMode && plasmoid.formFactor === PlasmaCore.Types.Horizontal) || plasmoid.formFactor === PlasmaCore.Types.Vertical   ? true : false
    Layout.fillHeight:  (inFillLengthMode && plasmoid.formFactor === PlasmaCore.Types.Vertical  ) || plasmoid.formFactor === PlasmaCore.Types.Horizontal ? true : false

    Layout.minimumWidth:          plasmoid.formFactor === PlasmaCore.Types.Horizontal ? minimumLength : 0
    Layout.preferredWidth:        plasmoid.formFactor === PlasmaCore.Types.Horizontal ? preferredLength : -1
    Layout.maximumWidth:          plasmoid.formFactor === PlasmaCore.Types.Horizontal ? maximumLength : -1

    Layout.minimumHeight:         plasmoid.formFactor === PlasmaCore.Types.Vertical ? minimumLength : 0
    Layout.preferredHeight:       plasmoid.formFactor === PlasmaCore.Types.Vertical ? preferredLength : -1
    Layout.maximumHeight:         plasmoid.formFactor === PlasmaCore.Types.Vertical ? maximumLength : -1

    preferredRepresentation:      fullRepresentation

    Plasmoid.status: {
        if (!inEditMode && fallBackText === "" && !existsWindowActive && Plasmoid.configuration.placeHolderIcon === "")  return PlasmaCore.Types.HiddenStatus;
        else                                                                                                             return PlasmaCore.Types.PassiveStatus;
    }

    readonly property bool inContentsLengthMode:    plasmoid.configuration.lengthPolicy === 0
    readonly property bool inFixedLengthMode:       plasmoid.configuration.lengthPolicy === 1
    readonly property bool inMaximumLengthMode:     plasmoid.configuration.lengthPolicy === 2
    readonly property bool inFillLengthMode:        plasmoid.configuration.lengthPolicy === 3
    readonly property bool inEditMode:              plasmoid.userConfiguring

    readonly property int minimumLength: {
        if (inContentsLengthMode)        return implicitTitleLength;
        else if (inFixedLengthMode)      return plasmoid.configuration.fixedLength;
        else if (inMaximumLengthMode)    return 0;
        else /*inFillLengthMode*/        return inEditMode ? 48 : 0;
    }
    readonly property int preferredLength: {
        if (inContentsLengthMode)      return implicitTitleLength;
        else if (inFixedLengthMode)    return plasmoid.configuration.fixedLength;
        else if (inMaximumLengthMode)  return Math.min(implicitTitleLength, plasmoid.configuration.maximumLength);
        else /*inFillLengthMode*/      return -1;
    }
    readonly property int maximumLength: {
        if (inContentsLengthMode)      return implicitTitleLength;
        else if (inFixedLengthMode)    return plasmoid.configuration.fixedLength;
        else if (inMaximumLengthMode)  return plasmoid.configuration.maximumLength;
        else  /*inFillLengthMode*/     return Infinity;
    }

    readonly property int thickness:                plasmoid.formFactor === PlasmaCore.Types.Horizontal ? root.height : root.width
    readonly property int implicitTitleLength:      plasmoid.formFactor === PlasmaCore.Types.Horizontal ? metricsContents.width : metricsContents.height

    readonly property bool existsWindowActive:      windowInfoLoader.item && windowInfoLoader.item.existsWindowActive
    readonly property bool isActiveWindowPinned:    existsWindowActive && activeTaskItem.isOnAllDesktops
    readonly property bool isActiveWindowMaximized: existsWindowActive && activeTaskItem.isMaximized

    readonly property bool isApplicationStyle:      plasmoid.configuration.style === 0
    readonly property bool isTitleStyle:            plasmoid.configuration.style === 1
    readonly property bool isApplicationTitleStyle: plasmoid.configuration.style === 2
    readonly property bool isTitleApplicationStyle: plasmoid.configuration.style === 3
    readonly property bool isNoTextStyle:           plasmoid.configuration.style === 4


    readonly property Item activeTaskItem: windowInfoLoader.item.activeTaskItem

    property string fallBackText: plasmoid.configuration.filterActivityInfo ? fullActivityInfo.name : plasmoid.configuration.placeHolder

    readonly property string firstTitleText: {
        if      (!activeTaskItem)                     return "";
        else if (isApplicationStyle)                  return Tools.applySubstitutes("%a",activeTaskItem.appName,activeTaskItem.title);
        else if (isTitleStyle)                        return activeTaskItem.title;
        else if (isTitleApplicationStyle)             return Tools.applySubstitutes("%w",activeTaskItem.appName,activeTaskItem.title);
        else if (isApplicationTitleStyle)             return activeTaskItem.appName === activeTaskItem.title ? Tools.applySubstitutes(activeTaskItem.appName) : activeTaskItem.title;
        else                                          return "";
    }

    readonly property string lastTitleText: {
        if (!activeTaskItem)                          return "";
        if (isApplicationTitleStyle)                  return activeTaskItem.appName === activeTaskItem.title ? "" : activeTaskItem.title;
        else if (isTitleApplicationStyle)             return activeTaskItem.appName === activeTaskItem.title ? "" : Tools.applySubstitutes("%a",activeTaskItem.appName,activeTaskItem.title);
        else                                          return "";
    }



    //-------------These are used to fetch information about activity and virtual isOnAllDesktops
    // Do Not Touch !!
    // BEGIN Tasks logic
    TaskManager.ActivityInfo { id: activityInfo }

    Activities.ActivityInfo {
        id: fullActivityInfo
        activityId: ":current"
    }
    TaskManager.VirtualDesktopInfo { id: virtualDesktopInfo }
    Loader {
        id: windowInfoLoader
        sourceComponent: plasmaTasksModel
        Component{
            id: plasmaTasksModel
            PlasmaTasksModel{}
        }
    }
    // END Tasks logic
    // -----------------------------------------------------------------------------
    // BEGIN Title Layout(s)

    // This Layout is used to count if the title overceeds the available space
    // in order for the Visible Layout to elide its contents
    TitleLayout {
        id: metricsContents
        anchors.top: parent.top
        anchors.left: parent.left
        opacity: 0
        isUsedForMetrics: true
    }

    // ---------------- ONLY THIS IS VISIBLE TO THE USER------------------------------
    TitleLayout {
        id: visibleContents
        anchors.top: parent.top
        anchors.left: parent.left
        width:                  plasmoid.formFactor === PlasmaCore.Types.Horizontal ? (!exceedsAvailableSpace ? metricsContents.width  : root.width ) : thickness
        height:                 plasmoid.formFactor === PlasmaCore.Types.Vertical   ? (!exceedsAvailableSpace ? metricsContents.height : root.height) : thickness
        exceedsAvailableSpace:  plasmoid.formFactor === PlasmaCore.Types.Horizontal ?                 metricsContents.width > root.width : metricsContents.height > root.height
        exceedsApplicationText: plasmoid.formFactor === PlasmaCore.Types.Horizontal ? metricsContents.applicationTextLength > root.width : metricsContents.applicationTextLength > root.height

        visible: plasmoid.configuration.filterActivityInfo || root.existsWindowActive || plasmoid.configuration.placeHolder || plasmoid.configuration.placeHolderIcon
    }
    // END Title Layout(s)
    // -----------------------------------------------------------------------------

    //! Tooltip Area
    PlasmaCore.ToolTipArea {
        id: contentsTooltip
        anchors.fill: visibleContents
        active: text !== ""
        interactive: true
        location: plasmoid.location

        readonly property string text: {
            if (!(existsWindowActive && plasmoid.configuration.showTooltip)) return "";
            else if (isApplicationStyle)                                     return activeTaskItem.appName === activeTaskItem.title ? "" : activeTaskItem.title;
            else if (isTitleApplicationStyle)                                return activeTaskItem.appName === activeTaskItem.title ?
                                                                                    Tools.applySubstitutes(activeTaskItem.appName)
                                                                                    : activeTaskItem.title + " - " + Tools.applySubstitutes(activeTaskItem.appName);
            else                                                             return activeTaskItem.appName === activeTaskItem.title ?
                                                                                    Tools.applySubstitutes(activeTaskItem.appName) :
                                                                                    Tools.applySubstitutes(activeTaskItem.appName) + " - " + activeTaskItem.title;
        }
        mainItem: RowLayout {
            spacing:                    Kirigami.Units.largeSpacing
            Layout.margins:             Kirigami.Units.smallSpacing
            Kirigami.Icon {
                Layout.minimumWidth:     Kirigami.Units.iconSizes.mediumSpacing * 1.0
                Layout.minimumHeight:    Kirigami.Units.iconSizes.mediumSpacing * 1.0
                Layout.maximumWidth:          Layout.minimumWidth
                Layout.maximumHeight:         Layout.minimumHeight
                source:  existsWindowActive ? activeTaskItem.icon : plasmoid.configuration.placeHolderIcon
                visible: !plasmoid.configuration.showIcon && (existsWindowActive || Plasmoid.configuration.placeHolderIcon !== "")
            }

            PlasmaComponents.Label {
                id: fullText
                Layout.minimumWidth: 0
                Layout.preferredWidth: implicitWidth
                Layout.maximumWidth: 750
                Layout.minimumHeight: implicitHeight
                Layout.maximumHeight: Layout.minimumHeight
                elide: Text.ElideRight
                text: contentsTooltip.text
            }
        }
    }
    //! END of ToolTip area

    Loader {
        id: actionsLoader
        anchors.fill: inFillLengthMode ? parent : visibleContents
        active: true
        sourceComponent: ActionsMouseArea {}
    }
}
