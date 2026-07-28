/*
 *  SPDX-FileCopyrightText: 2015 Kai Uwe Broulik <kde@privat.broulik.de>
 *
 *  SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Layouts 1.15

import org.kde.kirigami 2.20 as Kirigami
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami 2.20 as Kirigami
import org.kde.plasma.components 3.0 as PlasmaComponents3

PlasmaComponents3.ItemDelegate {
    id: item

    Layout.fillWidth: true

    property alias subText: sublabel.text
    property alias iconItem: iconItem.children
    property string customKeyUp: "Up"
    property string customKeyDown: "Down"

    highlighted: activeFocus

    Accessible.name: `${text}${subText ? `: ${subText}` : ""}`

    onHoveredChanged: if (hovered) {
        if (ListView.view) {
            ListView.view.currentIndex = index;
        }
        forceActiveFocus();
    }

    Keys.onReturnPressed: clicked()
    Keys.onEnterPressed: clicked()

    Keys.onPressed: function(event) {
        let seq = buildKeySequence(event);
        if (seq === customKeyUp) {
            let target = KeyNavigation.up;
            if (target && target.visible !== false) {
                target.forceActiveFocus();
                event.accepted = true;
            }
        } else if (seq === customKeyDown) {
            let target = KeyNavigation.down;
            if (target && target.visible !== false) {
                target.forceActiveFocus();
                event.accepted = true;
            }
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
        if ([Qt.Key_Control, Qt.Key_Shift, Qt.Key_Alt, Qt.Key_Meta].includes(key)) return "";
        return "";
    }

    contentItem: RowLayout {
        id: row

        spacing: Kirigami.Units.smallSpacing

        Item {
            id: iconItem

            Layout.preferredWidth: Kirigami.Units.iconSizes.smallMedium
            Layout.preferredHeight: Kirigami.Units.iconSizes.smallMedium
            Layout.minimumWidth: Layout.preferredWidth
            Layout.maximumWidth: Layout.preferredWidth
            Layout.minimumHeight: Layout.preferredHeight
            Layout.maximumHeight: Layout.preferredHeight
        }

        ColumnLayout {
            id: column
            Layout.fillWidth: true
            spacing: 0

            PlasmaComponents3.Label {
                id: label
                Layout.fillWidth: true
                text: item.text
                textFormat: Text.PlainText
                wrapMode: Text.NoWrap
                elide: Text.ElideRight
            }

            PlasmaComponents3.Label {
                id: sublabel
                Layout.fillWidth: true
                textFormat: Text.PlainText
                wrapMode: Text.NoWrap
                elide: Text.ElideRight
                opacity: 0.6
                font: Kirigami.Theme.smallFont
                visible: text !== ""
            }
        }
    }
}
