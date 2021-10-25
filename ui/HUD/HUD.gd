extends CanvasLayer

export (PackedScene) var SettingsScene

func _ready():
	# warning-ignore:return_value_discarded
	$SettingsButton.connect("button_up", self, "_on_SettingsButton_button_up")

func _on_SettingsButton_button_up():
	var settings_scene_instance = SettingsScene.instance()
	add_child(settings_scene_instance)
