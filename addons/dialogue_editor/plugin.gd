# Plugin DialogueEditor : MIT License
# @author Vladimir Petrenko
@tool
extends EditorPlugin

const IconResource = preload("res://addons/dialogue_editor/icons/Dialogue.png")
const DialogueMain = preload("res://addons/dialogue_editor/DialogueEditor.tscn")

# New Types
const DialogueDialogue2D = preload("res://addons/dialogue_editor/DialogueDialogue2D.gd")
const DialogueDialogue3D = preload("res://addons/dialogue_editor/DialogueDialogue3D.gd")
const DialogueIcon = preload("res://addons/dialogue_editor/icons/Dialogue.png")

var _dialogue_editor: Control = null
var _dialogue_editor_plugin: EditorInspectorPlugin = null

func _enter_tree():
	add_autoload_singleton("DialogueManager", "res://addons/dialogue_editor/DialogueManager.gd")
	_dialogue_editor = DialogueMain.instantiate()
	_dialogue_editor.name = "DialogueEditor"
	get_editor_interface().get_editor_main_screen().add_child(_dialogue_editor)
	_dialogue_editor.set_editor(self)
	_make_visible(false)
	add_custom_type("Dialogue2D", "Area2D", DialogueDialogue2D, DialogueIcon)
	add_custom_type("Dialogue3D", "Area3D", DialogueDialogue3D, DialogueIcon)
	_dialogue_editor_plugin = preload("res://addons/dialogue_editor/inspectors/DialogueMangerDialoguesInspectorPlugin.gd").new()
	_dialogue_editor_plugin.set_data(_dialogue_editor.get_data())
	add_inspector_plugin(_dialogue_editor_plugin)

func _exit_tree():
	remove_autoload_singleton("DialogueManager")
	if _dialogue_editor:
		_dialogue_editor.queue_free()
	remove_custom_type("Dialogue2D")
	remove_custom_type("Dialogue3D")
	remove_inspector_plugin(_dialogue_editor_plugin)

func _has_main_screen():
	return true

func _make_visible(visible):
	if _dialogue_editor:
		_dialogue_editor.visible = visible

func _get_plugin_name():
	return "Dialogue"

func _get_plugin_icon():
	return IconResource

#func save_external_data():
#	if _dialogue_editor:
#		_dialogue_editor.save_data()
