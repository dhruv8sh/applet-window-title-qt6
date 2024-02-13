import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.plasma.components as Components
import org.kde.kirigami as Kirigami

Item{
    id: main

    property bool locked: true

    readonly property int verticalSubHeight: height - (button.height/2)

    ColumnLayout{
        id: column
        spacing: 0
        opacity: locked ? 1 : 0.5

        Rectangle{
            id: subRectTop
            Layout.minimumWidth: button.width/2 + Layout.minimumHeight/2
            Layout.minimumHeight: 3
            Layout.maximumWidth: Layout.minimumWidth
            Layout.maximumHeight: Layout.minimumHeight

            color: palette.text
        }

        Rectangle {
            Layout.leftMargin: subRectTop.Layout.minimumWidth - subRectTop.Layout.minimumHeight
            Layout.minimumWidth: subRectTop.Layout.minimumHeight
            Layout.minimumHeight: verticalSubHeight
            Layout.maximumWidth: Layout.minimumWidth
            Layout.maximumHeight: Layout.minimumHeight
            color: palette.text
        }

        Kirigami.Icon{
            id: button
            width: 24
            height: 24
            source: locked ? "lock" : "unlock"
        }

        Rectangle {
            Layout.leftMargin: subRectTop.Layout.minimumWidth - subRectTop.Layout.minimumHeight
            Layout.minimumWidth: subRectTop.Layout.minimumHeight
            Layout.minimumHeight: verticalSubHeight
            Layout.maximumWidth: Layout.minimumWidth
            Layout.maximumHeight: Layout.minimumHeight
            color: palette.text
        }

        Rectangle{
            Layout.minimumWidth: subRectTop.Layout.minimumWidth
            Layout.minimumHeight: subRectTop.Layout.minimumHeight
            Layout.maximumWidth: Layout.minimumWidth
            Layout.maximumHeight: Layout.minimumHeight
            color: palette.text
        }
    }

    MouseArea{
        anchors.fill: column
        onClicked: locked = !locked;
    }

}
