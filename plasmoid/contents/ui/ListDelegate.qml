/*
 *  Copyright 2019 Davide Sandona' <sandona.davide@gmail.com>
 *  Copyright 2015 Kai Uwe Broulik <kde@privat.broulik.de>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>
 */

import QtQuick 2.2
import QtQuick.Layouts 1.1

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id: item

    readonly property bool textUnderIcon: plasmoid.configuration.textUnderIcon
    readonly property bool showText: plasmoid.configuration.showText

    signal clicked
    signal iconClicked

    property alias text: label.text
    property alias subText: sublabel.text
    property alias icon: icon.source
    // "enabled" also affects all children
    property bool interactive: true
    property bool interactiveIcon: false
    property alias usesPlasmaTheme: icon.usesPlasmaTheme
    property alias iconSize: icon.height
    property alias containsMouse: area.containsMouse
    property Item highlight
    readonly property int margins: plasmoid.configuration.margins

    property real fixedHeight: {
        if (showText) {
            if (textUnderIcon)
                return columnLabels.height + 2 * margins
            else
                return 2 * margins
        }
        else
            return 2 * margins
    }

    Layout.fillWidth: isVertical ? undefined : true
    Layout.preferredWidth: {
        console.log("## ASD: " + label.width + " - " + asdGrid.width)
        return isVertical ? iconSize * 8 : undefined
    }
    Layout.minimumHeight: units.iconSizes.tiny + fixedHeight
    Layout.maximumHeight: units.iconSizes.enormous + fixedHeight
    Layout.preferredHeight: {
        if (icon.height >= columnLabels.height)
            return icon.height + fixedHeight
        else
            return columnLabels.height + fixedHeight
    }

    MouseArea {
        id: area
        anchors.fill: parent
        enabled: item.interactive
        hoverEnabled: true
        onClicked: item.clicked()
        onContainsMouseChanged: {
            if (!highlight) {
                return
            }

            if (containsMouse) {
                highlight.parent = item
                highlight.width = item.width
                highlight.height = item.height
            }

            highlight.visible = containsMouse
        }
    }

    GridLayout {
        id: asdGrid
        anchors.fill: parent
        anchors.margins: margins
        flow: (textUnderIcon) ? GridLayout.TopToBottom : GridLayout.LeftToRight

        PlasmaCore.IconItem {
            id: icon
            anchors.horizontalCenter: (!showText || textUnderIcon) ? parent.horizontalCenter : undefined

            // gosh, there needs to be a Layout.fixedWidth
            Layout.minimumWidth: icon.height
            Layout.maximumWidth: icon.height
            Layout.minimumHeight: icon.height
            Layout.maximumHeight: icon.height

            MouseArea {
                anchors.fill: parent
                visible: item.interactiveIcon
                cursorShape: Qt.PointingHandCursor
                onClicked: item.iconClicked()
            }

        }

        ColumnLayout {
            id: columnLabels
            anchors.horizontalCenter: (!showText || textUnderIcon) ? icon.horizontalCenter : undefined
            spacing: 0
            visible: showText

            PlasmaComponents.Label {
                anchors.horizontalCenter: (!showText || textUnderIcon) ? parent.horizontalCenter : undefined
                id: label
                Layout.fillWidth: (textUnderIcon) ? false : true
                wrapMode: Text.NoWrap
                elide: Text.ElideRight
            }

            PlasmaComponents.Label {
                anchors.horizontalCenter: (!showText || textUnderIcon) ? parent.horizontalCenter : undefined
                id: sublabel
                Layout.fillWidth: (textUnderIcon) ? false : true
                wrapMode: Text.NoWrap
                elide: Text.ElideRight
                opacity: 0.6
                font: theme.smallestFont
                visible: text !== ""
            }
        }
    }
}
