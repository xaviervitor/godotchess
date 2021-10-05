extends Node2D

func _ready() -> void:
	$Board.connect("piece_moved", self, "_on_Board_piece_moved")
	$Board.connect("pawn_promoted", self, "_on_Board_pawn_promoted")
	set_board()
	$Board.snap_pieces_position($Board/Pieces.get_children())

func set_board(board = Constants.promotion_board) -> void:
	match board.to_move:
		"white":
			Global.player_turn = Constants.PLAYER.white
		"black":
			Global.player_turn = Constants.PLAYER.black
	
	for piece in board.black:
		$Board.add_piece_to_board(Constants.PLAYER.black, piece.type, Vector2(piece.position[0], piece.position[1]))
	
	for piece in board.white:
		$Board.add_piece_to_board(Constants.PLAYER.white, piece.type, Vector2(piece.position[0], piece.position[1]))

func _on_Board_piece_moved():
	Global.swap_player_turn()
	
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
#	$HUD/PromotionMenu.show()
	pawn.promote()
