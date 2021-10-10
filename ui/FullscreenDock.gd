extends Control

var maximize_icon = preload("res://assets/maximize.png")
var minimize_icon = preload("res://assets/minimize.png")

func _ready():
	$FullscreenButton.connect("button_up", self, "_on_FullscreenButton_button_up")
	
func _on_FullscreenButton_button_up():
	OS.window_fullscreen = !OS.window_fullscreen
	$FullscreenButton.icon = minimize_icon if $FullscreenButton.icon == maximize_icon else maximize_icon
