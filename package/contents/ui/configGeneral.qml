/*
 * Copyright 2019 Davide Sandona' <sandona.davide@gmail.com>
 * Copyright 2015 Kai Uwe Broulik <kde@privat.broulik.de>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License or (at your option) version 3 or any later version
 * accepted by the membership of KDE e.V. (or its successor approved
 * by the membership of KDE e.V.), which shall act as a proxy
 * defined in Section 14 of version 3 of the license.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>
 */

import QtQuick 2.0
import QtQuick.Controls 1.0 as QtControls
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.2

ColumnLayout {
    id: configPage

    Layout.minimumWidth: parent.width
    Layout.maximumWidth: parent.width
    Layout.preferredWidth: parent.width


    property bool cfg_showFace
    property bool cfg_showName
    property bool cfg_showFullName
    property alias cfg_showTechnicalInfo: showTechnicalInfoCheck.checked
    property alias cfg_showNewSession: showNewSession.checked
    property alias cfg_showLockScreen: showLockScreen.checked
    property alias cfg_showRestart: showRestart.checked
    property alias cfg_showShutdown: showShutdown.checked
    property alias cfg_showSuspend: showSuspend.checked
    property alias cfg_showHybernate: showHybernate.checked
    property alias cfg_showExit: showExit.checked
    property alias cfg_showUsers: showUsers.checked
    property alias cfg_leaveDirectly: leaveDirectly.checked
    property alias cfg_icon: icon.text
    property alias cfg_fontSize: fontSize.value

    QtControls.GroupBox {
        Layout.fillWidth: true
        title: i18n("User name display")
        // flat: true

        QtControls.ExclusiveGroup {
            id: nameEg
            onCurrentChanged: cfg_showFullName = (current === showFullNameRadio)
        }

        ColumnLayout {
            QtControls.RadioButton {
                id: showFullNameRadio
                Layout.fillWidth: true
                exclusiveGroup: nameEg
                text: i18n("Show full name (if available)")
                checked: cfg_showFullName
            }

            QtControls.RadioButton {
                Layout.fillWidth: true
                exclusiveGroup: nameEg
                text: i18n("Show login username")
                checked: !cfg_showFullName
            }
        }
    }

    QtControls.GroupBox {
        Layout.fillWidth: true
        title: i18n("Widget Layout")
        // flat: true

        QtControls.ExclusiveGroup {
            id: layoutEg
            onCurrentChanged: {
                cfg_showName = (current === showOnlyNameRadio || current === showBothRadio)
                cfg_showFace = (current === showOnlyFaceRadio || current === showBothRadio)
            }
        }

        ColumnLayout {
            QtControls.RadioButton {
                id: showOnlyNameRadio
                Layout.fillWidth: true
                exclusiveGroup: layoutEg
                text: i18n("Show only name")
                checked: cfg_showName && !cfg_showFace
            }

            QtControls.RadioButton {
                id: showOnlyFaceRadio
                Layout.fillWidth: true
                exclusiveGroup: layoutEg
                text: i18n("Show only avatar")
                checked: !cfg_showName && cfg_showFace
            }

            QtControls.RadioButton {
                id: showBothRadio
                Layout.fillWidth: true
                exclusiveGroup: layoutEg
                text: i18n("Show both avatar and name")
                checked: cfg_showName && cfg_showFace
            }

            QtControls.CheckBox {
                id: showTechnicalInfoCheck
                text: i18n("Show technical information about sessions")
            }

            QtControls.Label {
                text: i18n("Icon shown in the widget:")
            }

            RowLayout {
                QtControls.TextField {
                    id: icon
                    implicitWidth: 300
                }

                QtControls.Button {
                    iconName: 'folder'
                    onClicked: {
                        iconDialog.open()
                    }
                }
            }

            RowLayout {
                QtControls.Label {
                    text: i18n('Font size:')
                }

                QtControls.SpinBox {
                    id: fontSize
                    minimumValue: 10
                    maximumValue: 200
                    decimals: 0
                    stepSize: 5
                    suffix: ' %'
                }
            }
        }
    }

    QtControls.GroupBox {
        Layout.fillWidth: true
        title: i18n("Display")
        // flat: true

        ColumnLayout {
            Layout.fillWidth: true

            QtControls.Label {
                Layout.preferredWidth: parent.width
                Layout.maximumWidth: parent.width
                Layout.minimumWidth: parent.width
                wrapMode: Text.WordWrap
                text: i18n("By default, when clicking on the widget icon a list of options will appear. The following option let's you change this behaviour.")
            }

            QtControls.CheckBox {
                id: leaveDirectly
                text: i18n("Show the Leave dialog when click on the widget icon")
            }

            QtControls.Label {
                Layout.preferredWidth: parent.width
                Layout.maximumWidth: parent.width
                wrapMode: Text.WordWrap
                text: i18n("If the above option is unchecked, you can choose what to display on the appearing list.")
            }

            QtControls.CheckBox {
                id: showUsers
                text: i18n("Show Users menu entry")
            }

            QtControls.CheckBox {
                id: showNewSession
                text: i18n("Show New Session menu entry")
            }

            QtControls.CheckBox {
                id: showLockScreen
                text: i18n("Show Lock Screen menu entry")
            }

            QtControls.CheckBox {
                id: showRestart
                text: i18n("Show Restart menu entry")
            }

            QtControls.CheckBox {
                id: showShutdown
                text: i18n("Show Shutdown menu entry")
            }

            QtControls.CheckBox {
                id: showSuspend
                text: i18n("Show Suspend menu entry")
            }

            QtControls.CheckBox {
                id: showHybernate
                text: i18n("Show Hybernate menu entry")
            }

            QtControls.CheckBox {
                id: showExit
                text: i18n("Show Exit Window menu entry")
            }
        }
    }

    FileDialog {
        id: iconDialog
        title: 'Please choose an image file'
        folder: '/usr/share/icons/breeze/'
        nameFilters: ['Image files (*.png *.jpg *.xpm *.svg *.svgz)', 'All files (*)']
        onAccepted: {
            icon.text = iconDialog.fileUrl
        }
    }

    Item { // tighten layout
        Layout.fillHeight: true
    }
}
