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
    PlasmaCore.DataSource {
            id: executable
            engine: "executable"
            connectedSources: []
            property var callbacks: ({})
            onNewData: {
                var stdout = data["stdout"]

                if (callbacks[sourceName] !== undefined) {
                    callbacks[sourceName](stdout);
                }

                exited(sourceName, stdout)
                disconnectSource(sourceName) // exec finished
            }

            function exec(cmd, onNewDataCallback) {
                if (onNewDataCallback !== undefined){
                    callbacks[cmd] = onNewDataCallback
                }
                connectSource(cmd)
            }
            signal exited(string sourceName, string stdout)
    }

    readonly property bool showText: plasmoid.configuration.showText
    readonly property int margins: plasmoid.configuration.margins
    property real fixedWidth: ExternalJS.getIconSize(widgetListIconSize) + 2 * margins

    id: fullRoot

    Layout.preferredWidth: (showText) ? units.gridUnit * 12 : fixedWidth
    Layout.preferredHeight: Math.min(Screen.height * 0.7, column.contentHeight)

    Sessions.SessionsModel {
        id: sessionsModel
    }

    PlasmaComponents.Highlight {
        id: delegateHighlight
        visible: false
        z: -1 // otherwise it shows ontop of the icon/label and tints them slightly
    }

    ColumnLayout {
        id: column

        // there doesn't seem a more sensible way of getting this due to the expanding ListView
        readonly property int contentHeight: 0
                                            + (showUsers ? currentUserItem.height + userList.contentHeight + units.smallSpacing : 0)
                                            + (newSessionButton.visible ? newSessionButton.height : 0)
                                            + (lockScreenButton.visible ? lockScreenButton.height : 0)
                                            + (rebootButton.visible ? rebootButton.height : 0)
                                            + (shutdownButton.visible ? shutdownButton.height : 0)
                                            + (suspendButton.visible ? suspendButton.height : 0)
                                            + (hybernateButton.visible ? hybernateButton.height : 0)
                                            + (leaveButton.visible ? leaveButton.height : 0)

        anchors.fill: parent
        spacing: 0

        ListDelegate {
            id: currentUserItem
            text: root.displayedName
            subText: i18n("Current user")
            icon: kuser.faceIconUrl.toString() || "user-identity"
            interactive: false
            interactiveIcon: KCMShell.authorize("user_manager.desktop").length > 0
            onIconClicked: KCMShell.open("user_manager")
            usesPlasmaTheme: usesPlasmaThemeListIcon_sett
            iconSize: ExternalJS.getIconSize(widgetListIconSize)
            visible: showUsers
        }

        PlasmaExtras.ScrollArea {
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: showUsers

            ListView {
                id: userList
                model: sessionsModel

                highlight: PlasmaComponents.Highlight {}
                highlightMoveDuration: 0

                delegate: ListDelegate {
                    width: userList.width
                    text: {
                        if (!model.session) {
                            return i18nc("Nobody logged in on that session", "Unused")
                        }

                        if (model.realName && root.showFullName) {
                            return model.realName
                        }

                        return model.name
                    }
                    icon: model.icon || "user-identity"
                    subText: {
                        if (!root.showTechnicalInfo) {
                            return ""
                        }

                        if (model.isTty) {
                            return i18nc("User logged in on console number", "TTY %1", model.vtNumber)
                        } else if (model.displayNumber) {
                            return i18nc("User logged in on console (X display number)", "on %1 (%2)", model.vtNumber, model.displayNumber)
                        }
                        return ""
                    }

                    onClicked: sessionsModel.switchUser(model.vtNumber, sessionsModel.shouldLock)
                    onContainsMouseChanged: {
                        if (containsMouse) {
                            userList.currentIndex = index
                        } else {
                            userList.currentIndex = -1
                        }
                    }
                    usesPlasmaTheme: usesPlasmaThemeListIcon_sett
                }
            }
        }

        ListDelegate {
            id: newSessionButton
            text: i18n("New Session")
            icon: "system-switch-user"
            highlight: delegateHighlight
            visible: sessionsModel.canStartNewSession && showNewSession
            onClicked: sessionsModel.startNewSession(sessionsModel.shouldLock)
            usesPlasmaTheme: usesPlasmaThemeListIcon_sett
            iconSize: ExternalJS.getIconSize(widgetListIconSize)
        }

        ListDelegate {
            id: lockScreenButton
            text: i18n("Lock Screen")
            icon: "system-lock-screen"
            highlight: delegateHighlight
            enabled: pmEngine.data["Sleep States"]["LockScreen"]
            visible: enabled && showLockScreen
            onClicked: pmEngine.performOperation("lockScreen")
            usesPlasmaTheme: usesPlasmaThemeListIcon_sett
            iconSize: ExternalJS.getIconSize(widgetListIconSize)
        }

        ListDelegate {
            id: rebootButton
            text: i18nc("Restart", "Reboot...")
            highlight: delegateHighlight
            icon: "system-reboot"
            visible: showRestart
            onClicked: {
                executable.exec("qdbus org.kde.ksmserver /KSMServer logout 0 1 3");
            }
            usesPlasmaTheme: usesPlasmaThemeListIcon_sett
            iconSize: ExternalJS.getIconSize(widgetListIconSize)
        }

        ListDelegate {
            id: shutdownButton
            text: i18n("Shutdown")
            icon: "system-shutdown"
            highlight: delegateHighlight
            visible: showShutdown
            onClicked: {
                executable.exec('qdbus org.kde.ksmserver /KSMServer logout 0 2 2');
            }
            usesPlasmaTheme: usesPlasmaThemeListIcon_sett
            iconSize: ExternalJS.getIconSize(widgetListIconSize)
        }

        ListDelegate {
            id: suspendButton
            text: i18n("Suspend")
            icon: "system-suspend"
            highlight: delegateHighlight
            visible: showSuspend
            onClicked: {
                executable.exec('qdbus org.kde.Solid.PowerManagement /org/freedesktop/PowerManagement Suspend');
            }
            usesPlasmaTheme: usesPlasmaThemeListIcon_sett
            iconSize: ExternalJS.getIconSize(widgetListIconSize)
        }

        ListDelegate {
            id: hybernateButton
            text: i18n("Hybernate")
            icon: "system-suspend-hibernate"
            highlight: delegateHighlight
            visible: showHybernate
            onClicked: {
                executable.exec('qdbus org.kde.Solid.PowerManagement /org/freedesktop/PowerManagement Hibernate');
            }
            usesPlasmaTheme: usesPlasmaThemeListIcon_sett
            iconSize: ExternalJS.getIconSize(widgetListIconSize)
        }
        
        ListDelegate {
            id: leaveButton
            text: i18nc("Show a dialog with options to logout/shutdown/restart", "Leave...")
            highlight: delegateHighlight
            icon: "arrow-right"
            visible: showExit
            onClicked: pmEngine.performOperation("requestShutDown")
            usesPlasmaTheme: usesPlasmaThemeListIcon_sett
            iconSize: ExternalJS.getIconSize(widgetListIconSize)
        }
    }

    Component.onCompleted: {
        plasmoid.expandedChanged.connect(function (expanded) {
            if (expanded) {
                sessionsModel.reload();
            }
        });
    }
}
