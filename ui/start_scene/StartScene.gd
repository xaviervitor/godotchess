extends Control

var color_group = preload("res://ui/start_scene/ColorGroup.tres")
var chosen_color = "random"
func _ready():
	# warning-ignore:return_value_discarded
	$FullscreenButton.connect("button_up", self, "_on_FullscreenButton_button_up")
	# warning-ignore:return_value_discarded
	$Panel/StartButton.connect("button_up", self, "_on_StartButton_button_up")
	# warning-ignore:return_value_discarded
	$Panel/WhiteColorButton.connect("button_up", self, "_on_WhiteColorButton_button_up")
	# warning-ignore:return_value_discarded
	$Panel/RandomColorButton.connect("button_up", self, "_on_RandomColorButton_button_up")
	# warning-ignore:return_value_discarded
	$Panel/BlackColorButton.connect("button_up", self, "_on_BlackColorButton_button_up")

func _on_FullscreenButton_button_up():
	OS.window_fullscreen = !OS.window_fullscreen

func _on_StartButton_button_up():
	Boards.standard_board.to_move = chosen_color
	get_tree().change_scene("res://game/Game.tscn")

func _on_WhiteColorButton_button_up():
	chosen_color = "white"

func _on_RandomColorButton_button_up():
	chosen_color = "random"

func _on_BlackColorButton_button_up():
	chosen_color = "black"
