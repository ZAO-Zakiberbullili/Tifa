# Dialogues preview dialog for DialogueEditor : MIT License
# @author Vladimir Petrenko
@tool
extends Window

var _scene
var _data: DialogueData

@onready var _actor_ui = $Margin/VBox/HBoxName/Actor as OptionButton
@onready var _textures_ui = $Margin/VBox/HBoxTexture/Textures as OptionButton
@onready var _texture_ui = $Margin/VBox/Center/Texture as TextureRect
@onready var _buttons_add_ui = $Margin/VBox/VBoxAdd/HBoxAdd/Add as Button
@onready var _text_vbox_ui = $Margin/VBox/VBoxText as VBoxContainer
@onready var _clear_ui = $Margin/VBox/HBoxAction/Clear as Button
@onready var _close_ui = $Margin/VBox/HBoxAction/Close as Button

const DialogueScenePreviewSentenceDialogText = preload("res://addons/dialogue_editor/scenes/scenes/DialogueScenePreviewSentenceDialogText.tscn")

func set_data(scene, data: DialogueData) -> void:
	_scene = scene
	_data = data
	_check_scene()
	_init_connections()
	_draw_view()

func _check_scene() -> void:
	if not _scene.has("preview"):
		_scene["preview"] = { "texts": [""] }
	if not _scene["preview"].has("texts"):
		_scene["preview"]["texts"] = [""]
	if _scene["preview"]["texts"].is_empty():
		_scene["preview"]["texts"] = [""]
	if _is_scene_has_actor():
		if not _data.actors.has(_scene["preview"]["actor"]):
			_scene["preview"].erase("actor")
		else:
			var actor = _scene["preview"]["actor"]
			if _is_scene_has_texture_uuid():
				for resource in actor.resources:
					if resource.uuid == _scene["preview"]["texture_uuid"]:
						return
				_scene["preview"].erase("texture_uuid")
	else:
		_scene["preview"].erase("actor")
		_scene["preview"].erase("texture_uuid")

func _init_connections() -> void:
	if not _actor_ui.item_selected.is_connected(_on_item_actor_selected):
		_actor_ui.item_selected.connect(_on_item_actor_selected)
	if not _textures_ui.item_selected.is_connected(_on_item_textures_selected):
		_textures_ui.item_selected.connect(_on_item_textures_selected)
	if not _buttons_add_ui.pressed.is_connected(_on_add_pressed):
		_buttons_add_ui.pressed.connect(_on_add_pressed)
	if not _clear_ui.pressed.is_connected(_on_clear_pressed):
		_clear_ui.pressed.connect(_on_clear_pressed)
	if not _close_ui.pressed.is_connected(_on_close_pressed):
		_close_ui.pressed.connect(_on_close_pressed)
	if not close_requested.is_connected(_on_hide):
		close_requested.connect(_on_hide)

func _on_item_actor_selected(index: int) -> void:
	if index > 0:
		_scene["preview"]["actor"] = _data.actors[index - 1]
	else:
		_scene["preview"].erase("actor")
	_textures_ui_fill_and_draw()

func _on_item_textures_selected(index: int) -> void:
	if index > 0:
		var actor = _scene["preview"]["actor"]
		_scene["preview"]["texture_uuid"] = actor.resources[index - 1].uuid
	else:
		_scene["preview"].erase("texture_uuid")
	_draw_texture()

func _on_add_pressed() -> void:
	if _scene.has("preview") and _scene["preview"].has("texts"):
		_scene["preview"]["texts"].append("")
		_clear_and_draw_texts()

func _on_clear_pressed() -> void:
	_scene["preview"] = {}
	_draw_view()

func _on_close_pressed() -> void:
	_on_hide()
	hide()

func _on_hide() -> void:
	_data.emit_signal_scene_preview_data_changed(_scene)

func _draw_view() -> void:
	_actor_ui_fill_and_draw()
	_textures_ui_fill_and_draw()
	_draw_texture()
	_clear_and_draw_texts()

func _actor_ui_fill_and_draw() -> void:
	_actor_ui.clear()
	_actor_ui.disabled = true
	var scene_actor = null
	var select = -1
	if not _data.actors.is_empty():
		_actor_ui.disabled = false
		if _is_scene_has_actor():
			scene_actor = _scene["preview"]["actor"]
		_actor_ui.add_item("None", 0)
		select = 0
		for index in range(_data.actors.size()):
			var actor = _data.actors[index]
			if scene_actor == actor:
				select = index + 1
			if not actor.resources.is_empty():
				var image = load(actor.resources[0].path)
				image = _data.resize_texture(image, Vector2(16, 16))
				_actor_ui.add_icon_item(image, actor.name, index)
			else:
				_actor_ui.add_item(actor.name, index + 1)
		_actor_ui.select(select)

func _textures_ui_fill_and_draw() -> void:
	_textures_ui.clear()
	_textures_ui.disabled = true
	var scene_texture_uuid = null
	var select = -1
	if _is_scene_has_actor():
		var actor = _scene["preview"]["actor"]
		if not actor.resources.is_empty():
			_textures_ui.disabled = false
			if _is_scene_has_texture_uuid():
				scene_texture_uuid = _scene["preview"]["texture_uuid"]
			_textures_ui.add_item("None", 0)
			select = 0
			for index in range(actor.resources.size()):
				var resource = actor.resources[index]
				if scene_texture_uuid == resource.uuid:
					select = index + 1
				_textures_ui.add_item(resource.name, index + 1)
			_textures_ui.select(select)

func _draw_texture() -> void:
	_set_default_texture()
	if _is_scene_has_texture_uuid():
		var texture_uuid = _scene["preview"]["texture_uuid"]
		var actor = _scene["preview"]["actor"]
		var texture = actor.resource_by_uuid(texture_uuid)
		if texture:
			_texture_ui.texture = texture

func _set_default_texture() -> void:
	_texture_ui.texture = load("res://addons/dialogue_editor/icons/Image.png")

func _clear_and_draw_texts() -> void:
	_clear_texts()
	_draw_texts()

func _draw_texts() -> void:
	if _scene.has("preview") and _scene["preview"].has("texts"):
		for index in range(_scene["preview"]["texts"].size()):
			var text_ui = DialogueScenePreviewSentenceDialogText.instantiate()
			_text_vbox_ui.add_child(text_ui)
			text_ui.set_data(index, _scene)
			text_ui.delete_action.connect(_on_delete_action)
		set_size(Vector2(min_size.x, min_size.y + 34 * _scene["preview"]["texts"].size()))

func _on_delete_action() -> void:
	_clear_and_draw_texts()

func _clear_texts() -> void:
	for text_ui in _text_vbox_ui.get_children():
		_text_vbox_ui.remove_child(text_ui)
		text_ui.queue_free()

func _is_scene_has_actor() -> bool:
	return _scene.has("preview") and _scene["preview"].has("actor")

func _is_scene_has_texture_uuid() -> bool:
	return _is_scene_has_actor() and _scene["preview"].has("texture_uuid")
