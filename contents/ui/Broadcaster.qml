import QtQuick

import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore

Item{
    id: broadcaster

    readonly property bool showAppMenuEnabled: plasmoid.configuration.showAppMenuOnMouseEnter
    property bool menuIsPresent: false
    property var appMenusRequestCooperation: []
    property int appMenusRequestCooperationCount: 0

    readonly property bool cooperationEstablished: appMenusRequestCooperationCount>0 && isActive
    readonly property bool isActive: plasmoid.configuration.appMenuIsPresent && showAppMenuEnabled && (plasmoid.formFactor === PlasmaCore.Types.Horizontal)

    readonly property int sendActivateAppMenuCooperationFromEditMode: plasmoid.configuration.sendActivateAppMenuCooperationFromEditMode

    function sendMessage() {
        if (cooperationEstablished && menuIsPresent) {
            broadcasterDelayer.start();
        }
    }

    function cancelMessage() {
        if (cooperationEstablished) {
            broadcasterDelayer.stop();
        }
    }

    onSendActivateAppMenuCooperationFromEditModeChanged: {
        if (plasmoid.configuration.sendActivateAppMenuCooperationFromEditMode >= 0) {
            var values = {
                appletId: plasmoid.id,
                cooperation: plasmoid.configuration.sendActivateAppMenuCooperationFromEditMode
            };

            releaseSendActivateAppMenuCooperation.start();
        }
    }

    Timer{
        id: broadcasterDelayer
        interval: 5
        onTriggered: {
        }
    }

    Timer {
        id: releaseSendActivateAppMenuCooperation
        interval: 50
        onTriggered: plasmoid.configuration.sendActivateAppMenuCooperationFromEditMode = -1;
    }

    //!!!! MouseArea for Broadcaster
    MouseArea{
        id: broadcasterMouseArea
        anchors.fill: parent
        visible: broadcaster.cooperationEstablished && broadcaster.menuIsPresent
        hoverEnabled: true
        propagateComposedEvents: true

        property int mouseAX: -1
        property int mouseAY: -1

        //! HACK :: For some reason containsMouse breaks in some cases
        //! this hack is used in order to be sure when the mouse is really
        //! inside the MouseArea or not
        readonly property bool realContainsMouse: mouseAX !== -1 || mouseAY !== -1

        onContainsMouseChanged: {
            mouseAX = -1;
            mouseAY = -1;
        }

        onMouseXChanged: mouseAX = mouseX;
        onMouseYChanged: mouseAY = mouseY;

        onRealContainsMouseChanged: {
            if (broadcaster.cooperationEstablished) {
                if (realContainsMouse) {
                    broadcaster.sendMessage();
                } else {
                    broadcaster.cancelMessage();
                }
            }
        }

        onPressed: {
            mouse.accepted = false;
        }

        onReleased: {
            mouse.accepted = false;
        }
    }

}
