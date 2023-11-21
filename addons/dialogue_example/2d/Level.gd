# DialogueEditor example of Dialogues usage: MIT License
# @author Vladimir Petrenko
extends Node2D

var dialogueManager

@onready var _timer_ui = $Timer
@onready var _flag_red_ui = $FlagRed as Sprite2D
@onready var _flag_yellow_ui = $FlagYellow as Sprite2D

func _ready() -> void:
	if get_tree().get_root().has_node("DialogueManager"):
		dialogueManager = get_tree().get_root().get_node("DialogueManager")
		if not dialogueManager.dialogue_event.is_connected(_on_dialogue_event):
				assert(dialogueManager.dialogue_event.connect(_on_dialogue_event) == OK)

func _on_dialogue_event(event: String) -> void:
	if event == DialogueEvents.QUESTION_EVENT_RIGHT or event == DialogueEvents.QUESTION_EVENT_WRONG:
		_flag_yellow_ui.visible = event == DialogueEvents.QUESTION_EVENT_RIGHT
		_flag_red_ui.visible = event == DialogueEvents.QUESTION_EVENT_WRONG
		_timer_ui.start()
		if not _timer_ui.timeout.is_connected(_on_timeout):
			assert(_timer_ui.timeout.connect(_on_timeout) == OK)

func _on_timeout() -> void:
	_reset_flags()

func _reset_flags() -> void:
	_flag_yellow_ui.visible = false
	_flag_red_ui.visible = false
