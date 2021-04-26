extends Node2D

export (PackedScene) var Piece

func _ready() -> void:
	set_board()
	$Board.snap_pieces_position($Board/Pieces.get_children())

func set_board(board = Constants.standard_board) -> void:
	for piece in board.black:
		var instanced_piece = Piece.instance()
		instanced_piece.type = piece.type
		instanced_piece.color = Constants.PLAYER.black
		instanced_piece.board_coordinates = Vector2(piece.position[0], piece.position[1])
		$Board/Pieces.add_child(instanced_piece)
		
	for piece in board.white:
		var instanced_piece = Piece.instance()
		instanced_piece.type = piece.type
		instanced_piece.color = Constants.PLAYER.white
		instanced_piece.board_coordinates = Vector2(piece.position[0], piece.position[1])
		$Board/Pieces.add_child(instanced_piece)
