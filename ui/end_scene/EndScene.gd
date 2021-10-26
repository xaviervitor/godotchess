extends Control

var endgame_reason
var player
var other_player

var check_phrases = ["Nice!", "What a game!", "Wow!"]
var stale_phrases = ["That's a draw!", "What a game!", "Almost there!"]

func _ready():
	# warning-ignore:return_value_discarded
	$Popup/CloseButton.connect("button_up", self, "_on_CloseButton_button_up")
	
	randomize()
	var random_idx = randi() % 3
	$Popup/ReasonLabel.text = endgame_reason.capitalize() + "!"
	if endgame_reason == "checkmate":
		$Popup/DescriptionLabel.text = check_phrases[random_idx] + " The " + player + "s " + endgame_reason + "d the " + other_player + "s.\nBetter luck next time, " + other_player + "s!"
	elif endgame_reason == "stalemate":
		$Popup/DescriptionLabel.text = stale_phrases[random_idx] + " The " + player + "s almost had it.\n" + other_player.capitalize() + "s, that was a close call!"

func _on_CloseButton_button_up():
	queue_free()
