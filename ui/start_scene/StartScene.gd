extends Control

var color_group = preload("res://ui/start_scene/ColorGroup.tres")
var chosen_color = "white"
func _ready():
	# warning-ignore:return_value_discarded
	$StartButton.connect("button_up", self, "_on_StartButton_button_up")
	# warning-ignore:return_value_discarded
	$WhiteColorButton.connect("button_up", self, "_on_WhiteColorButton_button_up")
	# warning-ignore:return_value_discarded
	$RandomColorButton.connect("button_up", self, "_on_RandomColorButton_button_up")
	# warning-ignore:return_value_discarded
	$BlackColorButton.connect("button_up", self, "_on_BlackColorButton_button_up")

func _on_StartButton_button_up():
	Boards.standard_board.to_move = chosen_color
	get_tree().change_scene("res://game/Game.tscn")

func _on_WhiteColorButton_button_up():
	chosen_color = "white"

func _on_RandomColorButton_button_up():
	chosen_color = "random"

func _on_BlackColorButton_button_up():
	chosen_color = "black"
