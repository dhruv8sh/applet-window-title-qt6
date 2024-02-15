import QtQuick
import org.kde.plasma.core
import org.kde.plasma.plasmoid

MouseArea {
    id: actionsArea
    acceptedButtons: Qt.LeftButton | Qt.MiddleButton

    property bool wheelIsBlocked: false

    onClicked: function(event){
        if (existsWindowActive && event.button === Qt.MiddleButton) {
            windowInfoLoader.item.requestClose();
        }
    }

    onDoubleClicked: function(){
        if (existsWindowActive)
            windowInfoLoader.item.toggleMaximized();
    }

    onWheel: function(wheel) {
         if (wheelIsBlocked || !plasmoid.configuration.actionScrollMinimize) {
            return;
        }

        wheelIsBlocked = true;
        scrollDelayer.start();

        var delta = 0;

        if (wheel.angleDelta.y>=0 && wheel.angleDelta.x>=0) {
            delta = Math.max(wheel.angleDelta.y, wheel.angleDelta.x);
        } else {
            delta = Math.min(wheel.angleDelta.y, wheel.angleDelta.x);
        }

        var angle = delta / 8;

        var ctrlPressed = (wheel.modifiers & Qt.ControlModifier);

        if (angle>10) {
            //! upwards
            if (!ctrlPressed) {
                windowInfoLoader.item.activateNextPrevTask(true);
            } else if (windowInfoLoader.item.activeTaskItem
                       && !windowInfoLoader.item.activeTaskItem.isMaximized){
                windowInfoLoader.item.toggleMaximized();
            }
        } else if (angle<-10) {
            //! downwards
            if (!ctrlPressed) {
                if (windowInfoLoader.item.activeTaskItem
                        && !windowInfoLoader.item.activeTaskItem.isMinimized
                        && windowInfoLoader.item.activeTaskItem.isMaximized){
                    //! maximized
                    windowInfoLoader.item.activeTaskItem.toggleMaximized();
                } else if (windowInfoLoader.item.activeTaskItem
                           && !windowInfoLoader.item.activeTaskItem.isMinimized
                           && !windowInfoLoader.item.activeTaskItem.isMaximized) {
                    //! normal
                    windowInfoLoader.item.activeTaskItem.toggleMinimized();
                }
            } else if (windowInfoLoader.item.activeTaskItem
                       && windowInfoLoader.item.activeTaskItem.isMaximized) {
                windowInfoLoader.item.activeTaskItem.toggleMaximized();
            }
        }
    }

    //! A timer is needed in order to handle also touchpads that probably
    //! send too many signals very fast. This way the signals per sec are limited.
    //! The user needs to have a steady normal scroll in order to not
    //! notice a annoying delay
    Timer{
        id: scrollDelayer

        interval: 200
        onTriggered: actionsArea.wheelIsBlocked = false;
    }
}
