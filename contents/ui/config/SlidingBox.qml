import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami

Item {
    id: box
    clip: true

    x: parent.width/2 - width/2
    /*y: slideOutFrom === PlasmaCore.Types.BottomEdge ? 0
    height: 0*/
    opacity: 0
    property QtObject contentItem: null
    property int slideOutFrom: PlasmaCore.Types.TopEdge

    property bool shown: false

    readonly property int availableWidth: width - 2*12 - 2*Kirigami.Units.largeSpacing
    readonly property int availableHeight: contentItem.childrenRect.height + 2*Kirigami.Units.largeSpacing
    readonly property int maximumHeight: availableHeight + 2*12

    onContentItemChanged: {
        if (contentItem){
            contentItem.parent = centralItem
        }
    }

    function slideIn() {
        if (slideOutFrom === PlasmaCore.Types.TopEdge) {
            height = maximumHeight;
            y = -maximumHeight;
        } else {
            height = maximumHeight;
            y = parent.height;
        }

        opacity = 1;
        shown = true;
    }

    function slideOut() {
        if (slideOutFrom === PlasmaCore.Types.TopEdge) {
            height = 0;
            y = 0;
        } else {
            height = 0;
            y = parent.height;
        }

        opacity = 0;
        shown = false;
    }

    Behavior on y{
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }

    Behavior on height{
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }

    Behavior on opacity{
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }

    SystemPalette {
        id: palette
    }

    Item{
        id: mainElement
        width: parent.width
        height: contentItem ? maximumHeight : 100

        Rectangle{
            id: centralItem
            anchors.fill: parent
            anchors.margins: 12
            color: palette.alternateBase
            border.width: 1
            border.color: palette.mid
            radius: 5

            layer.enabled: true
        }
    }
}
