extends Control


var piece : Piece

func _ready():
	# warning-ignore:return_value_discarded
	$PromotionPopup/BishopButton.connect("button_up", self, "_on_BishopButton_button_up")
	# warning-ignore:return_value_discarded
	$PromotionPopup/HorseButton.connect("button_up", self, "_on_HorseButton_button_up")
	# warning-ignore:return_value_discarded
	$PromotionPopup/TowerButton.connect("button_up", self, "_on_TowerButton_button_up")
	# warning-ignore:return_value_discarded
	$PromotionPopup/QueenButton.connect("button_up", self, "_on_QueenButton_button_up")

func _on_BishopButton_button_up():
	choose_piece(Constants.PIECE_TYPE.bishop)

func _on_HorseButton_button_up():
	choose_piece(Constants.PIECE_TYPE.horse)

func _on_TowerButton_button_up():
	choose_piece(Constants.PIECE_TYPE.tower)

func _on_QueenButton_button_up():
	choose_piece(Constants.PIECE_TYPE.queen)

func choose_piece(type):
	piece.promote(type)
	queue_free()
