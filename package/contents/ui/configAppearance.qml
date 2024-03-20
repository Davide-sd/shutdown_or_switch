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

ColumnLayout {
    id: appearancePage

    Layout.minimumWidth: parent.width
    Layout.maximumWidth: parent.width
    Layout.preferredWidth: parent.width

    property alias cfg_usesPlasmaTheme: usesPlasmaTheme.checked
    property alias cfg_usesPlasmaThemeListIcon: usesPlasmaThemeListIcon.checked
    property alias cfg_widgetIconSize: widgetIconSizeCombo.currentIndex
    property alias cfg_widgetListIconSize: widgetListIconSizeCombo.currentIndex
    property alias cfg_textUnderIcon: textUnderIcon.checked
    property alias cfg_showText: showText.checked

    QtControls.GroupBox {
        Layout.fillWidth: true
        title: i18n("Appearance")
        // flat: true

        ColumnLayout {
            Layout.fillWidth: true

            QtControls.Label {
                Layout.preferredWidth: parent.width
                Layout.maximumWidth: parent.width
                Layout.minimumWidth: parent.width
                wrapMode: Text.WordWrap
                text: i18n("Plasma theme: it only applies for icon size Tiny, Small, Small-Medium.")
            }

            QtControls.CheckBox {
                id: usesPlasmaTheme
                text: i18n("Use plasma theme for widget icon")
            }

            QtControls.CheckBox {
                id: usesPlasmaThemeListIcon
                text: i18n("Use plasma theme for list icons")
            }

            RowLayout {
                QtControls.Label {
                    text: i18n("Widget Icon Size")
                }
                QtControls.ComboBox {
                    id: widgetIconSizeCombo
                    model: ["Default", "Tiny", "Small", "Small-Medium", "Medium", "Large", "Huge", "Enormous"]
                }
            }

            RowLayout {
                QtControls.Label {
                    text: i18n("List Icon Size")
                }
                QtControls.ComboBox {
                    id: widgetListIconSizeCombo
                    model: ["Default", "Tiny", "Small", "Small-Medium", "Medium", "Large", "Huge", "Enormous"]
                }
            }

            QtControls.Label {
                Layout.preferredWidth: parent.width
                Layout.maximumWidth: parent.width
                Layout.minimumWidth: parent.width
                wrapMode: Text.WordWrap
                text: i18n("Chose if and where to display the text in the list.")
            }

            QtControls.CheckBox {
                id: showText
                text: i18n("Display text")
            }

            QtControls.CheckBox {
                id: textUnderIcon
                text: i18n("Display text under icons")
            }
        }
    }

    Item { // tighten layout
        Layout.fillHeight: true
    }
}
