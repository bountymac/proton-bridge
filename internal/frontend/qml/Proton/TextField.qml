// Copyright (c) 2021 Proton Technologies AG
//
// This file is part of ProtonMail Bridge.
//
// ProtonMail Bridge is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// ProtonMail Bridge is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with ProtonMail Bridge.  If not, see <https://www.gnu.org/licenses/>.

import QtQml 2.12
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Templates 2.12 as T
import QtQuick.Layouts 1.12
import "."

Item {
    id: root
    property ColorScheme colorScheme

    property alias background: control.background
    property alias bottomInset: control.bottomInset
    property alias focusReason: control.focusReason
    property alias hoverEnabled: control.hoverEnabled
    property alias hovered: control.hovered
    property alias implicitBackgroundHeight: control.implicitBackgroundHeight
    property alias implicitBackgroundWidth: control.implicitBackgroundWidth
    property alias leftInset: control.leftInset
    property alias palette: control.palette
    property alias placeholderText: control.placeholderText
    property alias placeholderTextColor: control.placeholderTextColor
    property alias rightInset: control.rightInset
    property alias topInset: control.topInset
    property alias acceptableInput: control.acceptableInput
    property alias activeFocusOnPress: control.activeFocusOnPress
    property alias autoScroll: control.autoScroll
    property alias bottomPadding: control.bottomPadding
    property alias canPaste: control.canPaste
    property alias canRedo: control.canRedo
    property alias canUndo: control.canUndo
    property alias color: control.color
    //property alias contentHeight: control.contentHeight
    //property alias contentWidth: control.contentWidth
    property alias cursorDelegate: control.cursorDelegate
    property alias cursorPosition: control.cursorPosition
    property alias cursorRectangle: control.cursorRectangle
    property alias cursorVisible: control.cursorVisible
    property alias displayText: control.displayText
    property alias effectiveHorizontalAlignment: control.effectiveHorizontalAlignment
    property alias font: control.font
    property alias horizontalAlignment: control.horizontalAlignment
    property alias inputMask: control.inputMask
    property alias inputMethodComposing: control.inputMethodComposing
    property alias inputMethodHints: control.inputMethodHints
    property alias leftPadding: control.leftPadding
    property alias length: control.length
    property alias maximumLength: control.maximumLength
    property alias mouseSelectionMode: control.mouseSelectionMode
    property alias overwriteMode: control.overwriteMode
    property alias padding: control.padding
    property alias passwordCharacter: control.passwordCharacter
    property alias passwordMaskDelay: control.passwordMaskDelay
    property alias persistentSelection: control.persistentSelection
    property alias preeditText: control.preeditText
    property alias readOnly: control.readOnly
    property alias renderType: control.renderType
    property alias rightPadding: control.rightPadding
    property alias selectByMouse: control.selectByMouse
    property alias selectedText: control.selectedText
    property alias selectedTextColor: control.selectedTextColor
    property alias selectionColor: control.selectionColor
    property alias selectionEnd: control.selectionEnd
    property alias selectionStart: control.selectionStart
    property alias text: control.text
    property alias validator: control.validator
    property alias verticalAlignment: control.verticalAlignment
    property alias wrapMode: control.wrapMode

    implicitWidth: children[0].implicitWidth
    implicitHeight: children[0].implicitHeight

    property alias label: label.text
    property alias hint: hint.text
    property alias assistiveText: assistiveText.text

    property int echoMode: TextInput.Normal

    property bool error: false

    signal accepted()
    signal editingFinished()
    signal textEdited()

    function clear() { control.clear() }
    function copy() { control.copy() }
    function cut() { control.cut() }
    function deselect() { control.deselect() }
    function ensureVisible(position) { control.ensureVisible(position) }
    function getText(start, end) { control.getText(start, end) }
    function insert(position, text) { control.insert(position, text) }
    function isRightToLeft(start, end) { control.isRightToLeft(start, end) }
    function moveCursorSelection(position, mode) { control.moveCursorSelection(position, mode) }
    function paste() { control.paste() }
    function positionAt(x, y, position) { control.positionAt(x, y, position) }
    function positionToRectangle(pos) { control.positionToRectangle(pos) }
    function redo() { control.redo() }
    function remove(start, end) { control.remove(start, end) }
    function select(start, end) { control.select(start, end) }
    function selectAll() { control.selectAll() }
    function selectWord() { control.selectWord() }
    function undo() { control.undo() }
    function forceActiveFocus() { control.forceActiveFocus() }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        RowLayout {
            Layout.fillWidth: true
            spacing: 0

            Label {
                colorScheme: root.colorScheme
                id: label
                Layout.fillHeight: true
                Layout.fillWidth: true
                type: Label.LabelType.Body_semibold
            }

            Label {
                colorScheme: root.colorScheme
                id: hint
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: root.enabled ? root.colorScheme.text_weak : root.colorScheme.text_disabled
                horizontalAlignment: Text.AlignRight
                type: Label.LabelType.Caption
            }
        }

        // Background is moved away from within control to cover eye button as well.
        // In case it will remain as control background property - control's width
        // will be adjusted to background's width making text field and eye button overlap
        Rectangle {
            id: background

            Layout.fillHeight: true
            Layout.fillWidth: true

            radius: 4
            visible: true
            color: root.colorScheme.background_norm
            border.color: {
                if (!control.enabled) {
                    return root.colorScheme.field_disabled
                }

                if (control.activeFocus) {
                    return root.colorScheme.interaction_norm
                }

                if (root.error) {
                    return root.colorScheme.signal_danger
                }

                if (control.hovered) {
                    return root.colorScheme.field_hover
                }

                return root.colorScheme.field_norm
            }
            border.width: 1

            implicitWidth: children[0].implicitWidth
            implicitHeight: children[0].implicitHeight

            RowLayout {
                anchors.fill: parent
                spacing: 0

                T.TextField {
                    id: control

                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    implicitWidth: implicitBackgroundWidth + leftInset + rightInset
                                   || Math.max(contentWidth, placeholder.implicitWidth) + leftPadding + rightPadding
                    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                                             contentHeight + topPadding + bottomPadding,
                                             placeholder.implicitHeight + topPadding + bottomPadding)

                    padding: 8
                    leftPadding: 12

                    color: control.enabled ? root.colorScheme.text_norm : root.colorScheme.text_disabled

                    selectionColor: control.palette.highlight
                    selectedTextColor: control.palette.highlightedText
                    placeholderTextColor: control.enabled ? root.colorScheme.text_hint : root.colorScheme.text_disabled
                    verticalAlignment: TextInput.AlignVCenter

                    echoMode: eyeButton.checked ? TextInput.Normal : root.echoMode

                    cursorDelegate: Rectangle {
                        id: cursor
                        width: 1
                        color: root.colorScheme.interaction_norm
                        visible: control.activeFocus && !control.readOnly && control.selectionStart === control.selectionEnd

                        Connections {
                            target: control
                            onCursorPositionChanged: {
                                // keep a moving cursor visible
                                cursor.opacity = 1
                                timer.restart()
                            }
                        }

                        Timer {
                            id: timer
                            running: control.activeFocus && !control.readOnly
                            repeat: true
                            interval: Qt.styleHints.cursorFlashTime / 2
                            onTriggered: cursor.opacity = !cursor.opacity ? 1 : 0
                            // force the cursor visible when gaining focus
                            onRunningChanged: cursor.opacity = 1
                        }
                    }

                    PlaceholderText {
                        id: placeholder
                        x: control.leftPadding
                        y: control.topPadding
                        width: control.width - (control.leftPadding + control.rightPadding)
                        height: control.height - (control.topPadding + control.bottomPadding)

                        text: control.placeholderText
                        font: control.font
                        color: control.placeholderTextColor
                        verticalAlignment: control.verticalAlignment
                        visible: !control.length && !control.preeditText && (!control.activeFocus || control.horizontalAlignment !== Qt.AlignHCenter)
                        elide: Text.ElideRight
                        renderType: control.renderType
                    }

                    background: Item {
                        implicitWidth: 80
                        implicitHeight: 36
                        visible: false
                    }

                    onAccepted: {
                        root.accepted()
                    }
                    onEditingFinished: {
                        root.editingFinished()
                    }
                    onTextEdited: {
                        root.textEdited()
                    }
                }

                Button {
                    colorScheme: root.colorScheme
                    id: eyeButton

                    Layout.fillHeight: true

                    visible: root.echoMode === TextInput.Password
                    icon.color: control.color
                    background: Item { }
                    checkable: true
                    icon.source: checked ? "../icons/ic-eye-slash.svg" : "../icons/ic-eye.svg"
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 0

            ColorImage {
                id: errorIcon

                visible: root.error && (assistiveText.text.length > 0)
                source: "../icons/ic-exclamation-circle-filled.svg"
                color: root.colorScheme.signal_danger
            }

            Label {
                colorScheme: root.colorScheme
                id: assistiveText

                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.leftMargin: 4

                color: {
                    if (!root.enabled) {
                        return root.colorScheme.text_disabled
                    }

                    if (root.error) {
                        return root.colorScheme.signal_danger
                    }

                    return root.colorScheme.text_weak
                }

                type: root.error ? Label.LabelType.Caption_semibold : Label.LabelType.Caption
            }
        }
    }
}
