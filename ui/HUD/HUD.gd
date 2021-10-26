extends CanvasLayer

export (PackedScene) var SettingsScene

func _ready():
	# warning-ignore:return_value_discarded
	$SettingsButton.connect("button_up", self, "_on_SettingsButton_button_up")
	# warning-ignore:return_value_discarded
	$FullscreenButton.connect("button_up", self, "_on_FullscreenButton_button_up")
	# warning-ignore:return_value_discarded
	$CloseButton.connect("button_up", self, "_on_CloseButton_button_up")

func _on_SettingsButton_button_up():
	var settings_scene_instance = SettingsScene.instance()
	add_child(settings_scene_instance)

func _on_FullscreenButton_button_up():
	OS.window_fullscreen = !OS.window_fullscreen

func _on_CloseButton_button_up():
	get_tree().change_scene("res://ui/start_scene/StartScene.tscn")
