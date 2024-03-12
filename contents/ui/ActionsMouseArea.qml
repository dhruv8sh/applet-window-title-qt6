import QtQuick
import org.kde.plasma.core
import org.kde.plasma.plasmoid
import org.kde.plasma.plasma5support as Plasma5Support

MouseArea {
    id: actionsArea
    acceptedButtons: Qt.LeftButton | Qt.MiddleButton
    anchors.fill: parent
    property bool wheelIsBlocked: false

    onClicked: function(event){
        if (existsWindowActive && event.button === Qt.MiddleButton) windowInfoLoader.item.requestClose();
        else if( event.button === Qt.LeftButton ) executable.exec("qdbus org.kde.kglobalaccel /component/kwin invokeShortcut Overview");
    }
    onDoubleClicked: { if (existsWindowActive) windowInfoLoader.item.toggleMaximized(); }
    onWheel: function(wheel) {
        if (wheelIsBlocked || !plasmoid.configuration.actionScrollMinimize) return;
        wheelIsBlocked = true;
        scrollDelayer.start();
        var delta = 0;
        if (wheel.angleDelta.y>=0 && wheel.angleDelta.x>=0) delta = Math.max(wheel.angleDelta.y, wheel.angleDelta.x) / 8;
        else                                                delta = Math.min(wheel.angleDelta.y, wheel.angleDelta.x) / 8;
        var ctrlPressed = (wheel.modifiers & Qt.ControlModifier);
        if (delta>10) {
            if (!ctrlPressed)                                                                                    windowInfoLoader.item.activateNextPrevTask(true);
            else if (windowInfoLoader.item.activeTaskItem && !windowInfoLoader.item.activeTaskItem.isMaximized)  windowInfoLoader.item.toggleMaximized();
        } else if (delta<-10) {
            if (!ctrlPressed) {
                if (windowInfoLoader.item.activeTaskItem
                        && !windowInfoLoader.item.activeTaskItem.isMinimized
                        && windowInfoLoader.item.activeTaskItem.isMaximized)         // Maximized
                                            windowInfoLoader.item.activeTaskItem.toggleMaximized();
                else if (windowInfoLoader.item.activeTaskItem
                           && !windowInfoLoader.item.activeTaskItem.isMinimized
                           && !windowInfoLoader.item.activeTaskItem.isMaximized)     // UnMaximized
                                            windowInfoLoader.item.activeTaskItem.toggleMinimized();
            } else if (windowInfoLoader.item.activeTaskItem
                && windowInfoLoader.item.activeTaskItem.isMaximized)
                    windowInfoLoader.item.activeTaskItem.toggleMaximized();
        }
    }

    // To open overview
    Plasma5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        onNewData: (source, data) => { disconnectSource(source) }
        function exec(cmd) { executable.connectSource(cmd) }
    }

    // To optimize scrolling for touchpads
    Timer{
        id: scrollDelayer
        interval: 200
        onTriggered: actionsArea.wheelIsBlocked = false;
    }
}
