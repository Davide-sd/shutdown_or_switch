/*
 * SPDX-FileCopyrightText: 2024 Davide Sandonà <sandona.davide@gmail.com>
 * SPDX-FileCopyrightText: 2015 Kai Uwe Broulik <kde@privat.broulik.de>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.15
import QtQuick.Controls 2.15 as QtControls
import QtQuick.Layouts
import QtQuick.Dialogs

import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM
import org.kde.iconthemes as KIconThemes

KCM.SimpleKCM {
    property bool cfg_showIcon
    property bool cfg_showName
    property bool cfg_showFullName
    property alias cfg_shutdownConfirmation: shutdownConfirmation.currentIndex
    property alias cfg_rebootConfirmation: rebootConfirmation.currentIndex
    property alias cfg_logoutConfirmation: logoutConfirmation.currentIndex
    property alias cfg_showNewSession: showNewSession.checked
    property alias cfg_showLockScreen: showLockScreen.checked
    property alias cfg_showLogOut: showLogOut.checked
    property alias cfg_showRestart: showRestart.checked
    property alias cfg_showShutdown: showShutdown.checked
    property alias cfg_showSuspend: showSuspend.checked
    property alias cfg_showSuspendThenHibernate: showSuspendThenHibernate.checked
    property alias cfg_showHibernate: showHibernate.checked
    property alias cfg_showUsers: showUsers.checked
    property alias cfg_showText: showText.checked
    property alias cfg_icon: icon.text
    property string cfg_keyUp
    property string cfg_keyDown

    Kirigami.FormLayout {
        QtControls.ButtonGroup {
            id: nameGroup
        }

        QtControls.RadioButton {
            id: showFullNameRadio

            Kirigami.FormData.label: i18nc("@title:label", "Username style:")

            QtControls.ButtonGroup.group: nameGroup
            text: i18nc("@option:radio", "Full name (if available)")
            checked: cfg_showFullName
            onClicked: if (checked) cfg_showFullName = true;
        }

        QtControls.RadioButton {
            QtControls.ButtonGroup.group: nameGroup
            text: i18nc("@option:radio", "Login username")
            checked: !cfg_showFullName
            onClicked: if (checked) cfg_showFullName = false;
        }


        Item {
            Kirigami.FormData.isSection: true
        }


        QtControls.ButtonGroup {
            id: layoutGroup
        }

        QtControls.RadioButton {
            id: showOnlyNameRadio

            Kirigami.FormData.label: i18nc("@title:label", "Show:")

            QtControls.ButtonGroup.group: layoutGroup
            text: i18nc("@option:radio", "Name")
            checked: cfg_showName && !cfg_showIcon
            onClicked: {
                if (checked) {
                    cfg_showName = true;
                    cfg_showIcon = false;
                }
            }
        }

        QtControls.RadioButton {
            id: showOnlyFaceRadio

            QtControls.ButtonGroup.group: layoutGroup
            text: i18nc("@option:radio", "Icon")
            checked: !cfg_showName && cfg_showIcon
            onClicked: {
                if (checked) {
                    cfg_showName = false;
                    cfg_showIcon = true;
                }
            }
        }

        QtControls.RadioButton {
            id: showBothRadio

            QtControls.ButtonGroup.group: layoutGroup
            text: i18nc("@option:radio", "Icon and Name")
            checked: cfg_showName && cfg_showIcon
            onClicked: {
                if (checked) {
                    cfg_showName = true;
                    cfg_showIcon = true;
                }
            }
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        RowLayout {
            Kirigami.FormData.label: i18nc("@title:label", "Icon:")

            QtControls.TextField {
                id: icon
                implicitWidth: 300
            }

            QtControls.Button {
                icon.name: "folder"
                onClicked: {
                    iconDialog.open()
                }
            }
        }

        Item {
            Kirigami.FormData.isSection: true
        }


        QtControls.CheckBox {
            Kirigami.FormData.label: i18nc("@title:label", "Menu Entries:")
            id: showUsers
            text: i18nc("@option:check", "Users")
        }

        QtControls.CheckBox {
            id: showNewSession
            text: i18nc("@option:check", "New Session")
        }

        QtControls.CheckBox {
            id: showLockScreen
            text: i18nc("@option:check", "Lock Screen")
        }

        QtControls.CheckBox {
            id: showLogOut
            text: i18nc("@option:check", "Log Out")
        }

        QtControls.CheckBox {
            id: showRestart
            text: i18nc("@option:check", "Restart")
        }

        QtControls.CheckBox {
            id: showShutdown
            text: i18nc("@option:check", "Shutdown")
        }

        QtControls.CheckBox {
            id: showSuspend
            text: i18nc("@option:check", "Suspend")
        }

        QtControls.CheckBox {
            id: showSuspendThenHibernate
            text: i18nc("@option:check", "Suspend then Hibernate")
        }

        QtControls.CheckBox {
            id: showHibernate
            text: i18nc("@option:check", "Hibernate")
        }

        QtControls.CheckBox {
            Kirigami.FormData.label: i18nc("@title:label", "Show text on Menu Entries:")
            id: showText
            text: ""
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        QtControls.ComboBox {
            Kirigami.FormData.label: i18nc("@title:label", "Confirmation on Shutdown:")
            id: shutdownConfirmation
            model: ["Follow System", "Don't ask", "Always ask"]
            currentIndex: 1
        }

        QtControls.ComboBox {
            Kirigami.FormData.label: i18nc("@title:label", "Confirmation on Reboot:")
            id: rebootConfirmation
            model: ["Follow System", "Don't ask", "Always ask"]
            currentIndex: 1
        }

        QtControls.ComboBox {
            Kirigami.FormData.label: i18nc("@title:label", "Confirmation on Logout:")
            id: logoutConfirmation
            model: ["Follow System", "Don't ask", "Always ask"]
            currentIndex: 1
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18nc("@title:group", "Keyboard Navigation")
        }

        RowLayout {
            Kirigami.FormData.label: i18nc("@label", "Navigate Up:")
            spacing: Kirigami.Units.smallSpacing

            QtControls.TextField {
                id: keyUpField
                Layout.preferredWidth: Kirigami.Units.gridUnit * 10
                readOnly: true
                text: cfg_keyUp || i18nc("@info:placeholder", "None")
            }

            QtControls.Button {
                id: captureUpButton
                checkable: true
                text: checked ? i18nc("@action:button", "Press key...") : i18nc("@action:button", "Set")
                onCheckedChanged: if (checked) keyUpCapture.forceActiveFocus()
            }

            QtControls.Button {
                icon.name: "edit-clear"
                onClicked: cfg_keyUp = ""
            }

            Item {
                id: keyUpCapture
                width: 0; height: 0
                focus: captureUpButton.checked
                Keys.onPressed: function(event) {
                    if (!captureUpButton.checked) return;
                    let seq = buildKeySequence(event);
                    if (seq) {
                        cfg_keyUp = seq;
                        captureUpButton.checked = false;
                        event.accepted = true;
                    }
                }
            }
        }

        RowLayout {
            Kirigami.FormData.label: i18nc("@label", "Navigate Down:")
            spacing: Kirigami.Units.smallSpacing

            QtControls.TextField {
                id: keyDownField
                Layout.preferredWidth: Kirigami.Units.gridUnit * 10
                readOnly: true
                text: cfg_keyDown || i18nc("@info:placeholder", "None")
            }

            QtControls.Button {
                id: captureDownButton
                checkable: true
                text: checked ? i18nc("@action:button", "Press key...") : i18nc("@action:button", "Set")
                onCheckedChanged: if (checked) keyDownCapture.forceActiveFocus()
            }

            QtControls.Button {
                icon.name: "edit-clear"
                onClicked: cfg_keyDown = ""
            }

            Item {
                id: keyDownCapture
                width: 0; height: 0
                focus: captureDownButton.checked
                Keys.onPressed: function(event) {
                    if (!captureDownButton.checked) return;
                    let seq = buildKeySequence(event);
                    if (seq) {
                        cfg_keyDown = seq;
                        captureDownButton.checked = false;
                        event.accepted = true;
                    }
                }
            }
        }

        QtControls.Label {
            Layout.fillWidth: true
            Layout.topMargin: Kirigami.Units.largeSpacing
            wrapMode: Text.WordWrap
            text: i18nc("@info", "Click 'Set' and press the desired key combination. Default: Up/Down arrows.\nExamples: Up, Down, Ctrl+N, Ctrl+P")
            font: Kirigami.Theme.smallFont
            opacity: 0.7
        }

    }

    KIconThemes.IconDialog {
        id: iconDialog

        onIconNameChanged: iconName => {
            cfg_icon = iconName;
        }
    }

    function buildKeySequence(event) {
        let modifiers = [];
        if (event.modifiers & Qt.ControlModifier) modifiers.push("Ctrl");
        if (event.modifiers & Qt.ShiftModifier) modifiers.push("Shift");
        if (event.modifiers & Qt.AltModifier) modifiers.push("Alt");
        if (event.modifiers & Qt.MetaModifier) modifiers.push("Meta");

        let keyName = getKeyName(event.key);
        if (keyName === "") return "";

        return modifiers.length > 0 ? modifiers.join("+") + "+" + keyName : keyName;
    }

    function getKeyName(key) {
        const keyMap = {
            [Qt.Key_Up]: "Up",
            [Qt.Key_Down]: "Down",
            [Qt.Key_Left]: "Left",
            [Qt.Key_Right]: "Right",
            [Qt.Key_Return]: "Return",
            [Qt.Key_Enter]: "Enter",
            [Qt.Key_Escape]: "Escape",
            [Qt.Key_Tab]: "Tab",
            [Qt.Key_Backspace]: "Backspace",
            [Qt.Key_Space]: "Space",
            [Qt.Key_Home]: "Home",
            [Qt.Key_End]: "End",
            [Qt.Key_PageUp]: "PageUp",
            [Qt.Key_PageDown]: "PageDown",
            [Qt.Key_Insert]: "Insert",
            [Qt.Key_Delete]: "Delete",
            [Qt.Key_F1]: "F1", [Qt.Key_F2]: "F2", [Qt.Key_F3]: "F3",
            [Qt.Key_F4]: "F4", [Qt.Key_F5]: "F5", [Qt.Key_F6]: "F6",
            [Qt.Key_F7]: "F7", [Qt.Key_F8]: "F8", [Qt.Key_F9]: "F9",
            [Qt.Key_F10]: "F10", [Qt.Key_F11]: "F11", [Qt.Key_F12]: "F12",
        };

        if (key in keyMap) return keyMap[key];
        if (key >= Qt.Key_A && key <= Qt.Key_Z) return String.fromCharCode(key);
        if (key >= Qt.Key_0 && key <= Qt.Key_9) return String.fromCharCode(key);
        return "";
    }
}
