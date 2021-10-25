extends Button

var maximize_icon = preload("res://assets/ui/maximize.png")
var minimize_icon = preload("res://assets/ui/minimize.png")

var button_state = false

func _ready():
	# warning-ignore:return_value_discarded
	connect("button_up", self, "_on_FullscreenButton_button_up")
	update_icon()
	
func _on_FullscreenButton_button_up():
	OS.window_fullscreen = !OS.window_fullscreen
	button_state = !button_state
	update_icon()

func update_icon():
	icon = minimize_icon if button_state else maximize_icon
