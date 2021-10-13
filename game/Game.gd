extends Node2D

export (PackedScene) var PromotionScene

func _ready() -> void:
	# warning-ignore:return_value_discarded
	$Board.connect("piece_moved", self, "_on_Board_piece_moved")
	# warning-ignore:return_value_discarded
	$Board.connect("pawn_promoted", self, "_on_Board_pawn_promoted")
	# warning-ignore:return_value_discarded
	$Board.connect("checkmate", self, "_on_Board_checkmate")
	# warning-ignore:return_value_discarded
	$Board.connect("stalemate", self, "_on_Board_stalemate")
	set_board()
	$Board.snap_pieces_position($Board/Pieces.get_children())

func set_board(board = Constants.check_board) -> void:
	for piece in board.black:
		$Board.add_piece_to_board(Constants.PLAYER.black, piece.type, Vector2(piece.position[0], piece.position[1]))
	
	for piece in board.white:
		$Board.add_piece_to_board(Constants.PLAYER.white, piece.type, Vector2(piece.position[0], piece.position[1]))
	
	match board.to_move:
		"white":
			Global.set_player_turn(Constants.PLAYER.white)
		"black":
			Global.set_player_turn(Constants.PLAYER.black)
			rotate_board()

func _on_Board_piece_moved():
	Global.swap_player_turn()
	if $Board.game_over():
		pass
	else:
		rotate_board()

func rotate_board():
	if Global.game_mode == Constants.GAME_MODE.local_multiplayer:
		var angle_to
		if $Camera.rotation_degrees != 0:
			angle_to = 0
		else:
			angle_to = 180
		
		$Camera.rotation_degrees = angle_to
		var pieces = $Board/Pieces.get_children()
		for piece in pieces:
			piece.rotation_degrees = angle_to

func _on_Board_pawn_promoted(pawn):
	var promotion_scene = PromotionScene.instance()
	promotion_scene.piece = pawn
	$HUD.add_child(promotion_scene)

func _on_Board_checkmate(player):
	print("checkmate of ", Global.player_to_string(player))

func _on_Board_stalemate(player):
	print("stalemate of ", Global.player_to_string(player))
