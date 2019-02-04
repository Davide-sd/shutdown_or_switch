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
import QtQuick.Controls 1.1 as QtControls
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.kcoreaddons 1.0 as KCoreAddons // kuser
import org.kde.kquickcontrolsaddons 2.0 // kcmshell

import org.kde.plasma.private.sessions 2.0 as Sessions

import "js/index.js" as ExternalJS

Item {
    id: root

    readonly property bool isVertical: plasmoid.formFactor === PlasmaCore.Types.Vertical

    readonly property string displayedName: showFullName ? kuser.fullName : kuser.loginName

    readonly property string icon_sett: plasmoid.configuration.icon
    readonly property int widgetIconSize: plasmoid.configuration.widgetIconSize
    readonly property int widgetListIconSize: plasmoid.configuration.widgetListIconSize
    readonly property bool showFace: plasmoid.configuration.showFace
    readonly property bool showName: plasmoid.configuration.showName
    readonly property bool showFullName: plasmoid.configuration.showFullName
    readonly property bool usesPlasmaTheme_sett: plasmoid.configuration.usesPlasmaTheme
    readonly property bool usesPlasmaThemeListIcon_sett: plasmoid.configuration.usesPlasmaThemeListIcon
    readonly property bool showNewSession: plasmoid.configuration.showNewSession
    readonly property bool showLockScreen: plasmoid.configuration.showLockScreen
    readonly property bool showUsers: plasmoid.configuration.showUsers
    readonly property bool leaveDirectly: plasmoid.configuration.leaveDirectly
    readonly property int fontSize: plasmoid.configuration.fontSize

    // TTY number and X display
    readonly property bool showTechnicalInfo: plasmoid.configuration.showTechnicalInfo

    Plasmoid.switchWidth: units.gridUnit * 10
    Plasmoid.switchHeight: units.gridUnit * 12

    Plasmoid.toolTipTextFormat: Text.StyledText
    Plasmoid.toolTipMainText: {
        if (leaveDirectly)
            return i18n("Leave")
        else {
            if (showUsers)
                return i18n("Leave or Switch")
            else
                return i18n("Leave")
        }
    }
    Plasmoid.toolTipSubText: {
        if (leaveDirectly)
            return i18n("Launch Leave options dialog")
        else {
            if (showUsers)
                return i18n("You are logged in as <b>%1</b>", displayedName)
            else
                return i18n("Shows Leave options")
        }
    }

    Binding {
        target: plasmoid
        property: "icon"
        value: kuser.faceIconUrl
        // revert to the plasmoid icon if no face given
        when: kuser.faceIconUrl.toString() !== ""
    }

    KCoreAddons.KUser {
        id: kuser
    }

    PlasmaCore.DataSource {
        id: pmEngine
        engine: "powermanagement"
        connectedSources: ["PowerDevil", "Sleep States"]

        function performOperation(what) {
            var service = serviceForSource("PowerDevil")
            var operation = service.operationDescription(what)
            service.startOperationCall(operation)
        }
    }

    Plasmoid.compactRepresentation: MouseArea {
        id: compactRoot

        // Taken from DigitalClock to ensure uniform sizing when next to each other
        readonly property bool tooSmall: plasmoid.formFactor === PlasmaCore.Types.Horizontal && Math.round(2 * (compactRoot.height / 5)) <= theme.smallestFont.pixelSize

        Layout.minimumWidth: isVertical ? 0 : compactRow.implicitWidth
        Layout.maximumWidth: isVertical ? Infinity : Layout.minimumWidth
        Layout.preferredWidth: isVertical ? undefined : Layout.minimumWidth

        Layout.minimumHeight: isVertical ? units.iconSizes.tiny + label.height + units.smallSpacing : theme.smallestFont.pixelSize
        Layout.maximumHeight: isVertical ? units.iconSizes.enormous + label.height + units.smallSpacing : Infinity
        Layout.preferredHeight: isVertical ? compactRoot.Width  : theme.mSize(theme.defaultFont).height * 2

        onClicked: {
            if (!leaveDirectly) plasmoid.expanded = !plasmoid.expanded
            else {
                pmEngine.performOperation("requestShutDown")
            }
        }

        GridLayout {
            id: compactRow
            anchors.centerIn: parent
            flow: isVertical ? GridLayout.TopToBottom : GridLayout.LeftToRight
            rowSpacing: 0
            columnSpacing: units.smallSpacing

            PlasmaCore.IconItem {
                id: icon
                anchors.verticalCenter: isVertical ? undefined : parent.verticalCenter
                anchors.horizontalCenter: isVertical ? parent.horizontalCenter : undefined
                Layout.minimumWidth: units.iconSizes.tiny
                Layout.minimumHeight: units.iconSizes.tiny
                Layout.maximumWidth: units.iconSizes.enormous
                Layout.maximumHeight: units.iconSizes.enormous
                Layout.preferredWidth: ExternalJS.getIconSize(widgetIconSize, compactRoot)
                Layout.preferredHeight: Layout.preferredWidth
                source: visible ? (icon_sett || kuser.faceIconUrl.toString() || "user-identity") : ""
                visible: root.showFace
                usesPlasmaTheme: usesPlasmaTheme_sett
            }

            PlasmaComponents.Label {
                id: label
                Layout.fillWidth: isVertical ? true : undefined
                text: root.displayedName
                height: compactRoot.height
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.NoWrap
                fontSizeMode: isVertical ? Text.HorizontalFit : undefined
                font.pixelSize: {
                    if (isVertical)
                        return undefined
                    else
                        return tooSmall ? theme.defaultFont.pixelSize : units.roundToIconSize(units.gridUnit * 2) * fontSize / 100
                }
                minimumPointSize: theme.smallestFont.pointSize
                visible: root.showName
            }
        }
    }

    Plasmoid.fullRepresentation: FullRepresentation {}
}
