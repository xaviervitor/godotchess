extends Node2D

export (PackedScene) var Piece

func _ready() -> void:
	set_board()
	$Board.snap_pieces_position($Board/Pieces.get_children())

func set_board(board = Constants.standard_board) -> void:
	for piece in board.black:
		add_piece_to_board(Constants.PLAYER.black, piece.type, Vector2(piece.position[0], piece.position[1]))
	
	for piece in board.white:
		add_piece_to_board(Constants.PLAYER.white, piece.type, Vector2(piece.position[0], piece.position[1]))

func add_piece_to_board(color, type, piece_position):
	var instanced_piece = Piece.instance()
	instanced_piece.type = type
	instanced_piece.color = color
	instanced_piece.board_coordinates = piece_position
	$Board.board_matrix[piece_position.x][piece_position.y] = instanced_piece
	$Board/Pieces.add_child(instanced_piece)
