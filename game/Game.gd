extends Node2D

export (PackedScene) var Piece

func _ready() -> void:
	Global.player_turn = Constants.PLAYER.white
	$Board.connect("piece_moved", self, "_on_Board_piece_moved")
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

func _on_Board_piece_moved():
	Global.swap_player_turn()
	
	var angle_to
	if $Camera2D.rotation_degrees != 0:
		angle_to = 0
	else:
		angle_to = 180

	$Camera2D.rotation_degrees = angle_to
	var pieces = $Board/Pieces.get_children()
	for piece in pieces:
		piece.rotation_degrees = angle_to
