extends Button

func _ready():
	# warning-ignore:return_value_discarded
	connect("button_up", self, "_on_FullscreenButton_button_up")

func _on_FullscreenButton_button_up():
	OS.window_fullscreen = !OS.window_fullscreen
