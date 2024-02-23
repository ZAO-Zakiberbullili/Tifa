extends Control


func _ready():
	$"New Game".pressed.connect(self._on_StartButton_pressed)
	$Quit.pressed.connect(self._on_QuitButton_pressed)


func _on_StartButton_pressed():
	get_tree().change_scene_to_file("playground.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()
