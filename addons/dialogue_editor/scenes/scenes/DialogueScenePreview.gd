# Dialogues scene preview for DialogueEditor : MIT License
# @author Vladimir Petrenko
@tool
extends MarginContainer

var _scene
var _loaded_scene
var _data: DialogueData

@onready var _margin_ui = $Margin
@onready var _preview_ui = $Margin/Preview

func set_data(data: DialogueData) -> void:
	_data = data
	_scene = _data.selected_scene()
	_init_connections()
	_update_view()

func _init_connections() -> void:
	if not _data.scene_selection_changed.is_connected(_on_scene_selection_changed):
		_data.scene_selection_changed.connect(_on_scene_selection_changed)
	if not _data.scene_preview_data_changed.is_connected(_on_scene_preview_data_changed):
		_data.scene_preview_data_changed.connect(_on_scene_preview_data_changed)
	if not _data.scene_added.is_connected(_on_scene_added):
		_data.scene_added.connect(_on_scene_added)
	if not _data.scene_removed.is_connected(_on_scene_removed):
		_data.scene_removed.connect(_on_scene_removed)
	if not resized.is_connected(_on_resized):
		resized.connect(_on_resized)

func _on_scene_selection_changed(scene) -> void:
	_scene = scene
	_update_view()

func _on_scene_preview_data_changed(scene) -> void:
	if _scene == scene:
		_update_view()

func _on_scene_added(scene) -> void:
	_update_view()

func _on_scene_removed(scene) -> void:
	_update_view()

func _on_resized() -> void:
	_update_view()

func _update_view() -> void:
	_clear_view()
	_draw_view()
	_draw_sentence()

func _draw_view() -> void:
	if _scene:
		var LoadedScene = load(_scene.resource)
		_loaded_scene = LoadedScene.instantiate()
		_add_reference_rect()
		var display_size = _data.setting_display_size()
		var default_size = size
		var scale = min(default_size.x / display_size.x, default_size.y / display_size.y)
		_loaded_scene.set_custom_minimum_size(display_size)
		if scale < 1:
			_loaded_scene.set_scale(Vector2(scale, scale))
		_preview_ui.add_child(_loaded_scene)

func _add_reference_rect() -> void:
	var ref_rect = ReferenceRect.new()
	ref_rect.border_color = Color.WHITE
	ref_rect.editor_only = false
	ref_rect.anchor_right  = 1
	ref_rect.anchor_bottom = 1
	_loaded_scene.add_child(ref_rect)

func _clear_view() -> void:
	for child_ui in _preview_ui.get_children():
		_preview_ui.remove_child(child_ui)
		child_ui.queue_free()

func _draw_sentence() -> void:
	if _scene:
		var sentence = _build_dialogue_sentence()
		_loaded_scene.sentence_set(sentence)

func _build_dialogue_sentence() -> DialogueSentence:
	var sentence = DialogueSentence.new()
	if _scene.has("preview"):
		if _scene["preview"].has("actor"):
			sentence.actor = _scene["preview"]["actor"]
		if _scene["preview"].has("texture_uuid"):
			sentence.texture_uuid = _scene["preview"]["texture_uuid"]
		if _scene["preview"].has("texts"):
			sentence.texte_events.clear()
			for text in _scene["preview"]["texts"]:
				sentence.texte_events.append({"text": text, "event": null})
	return sentence
