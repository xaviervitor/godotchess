extends Button

var maximize_icon = preload("res://assets/ui/maximize.png")
var minimize_icon = preload("res://assets/ui/minimize.png")

func _ready():
	# warning-ignore:return_value_discarded
	connect("button_up", self, "_on_FullscreenButton_button_up")
	
func _on_FullscreenButton_button_up():
	OS.window_fullscreen = !OS.window_fullscreen
	icon = minimize_icon if OS.window_fullscreen else maximize_icon
