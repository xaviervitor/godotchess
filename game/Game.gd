extends Node

export (PackedScene) var Piece
var board

func _ready():
	set_board()
	snap_pieces_position()

func set_board():
	board = Constants.standard_board
	for piece in board.black:
		var instanced_piece = Piece.instance()
		instanced_piece.type = piece.type
		instanced_piece.color = Constants.PLAYER.black
		instanced_piece.board_position = Vector2(piece.position[0], piece.position[1])
		$Board/Pieces.add_child(instanced_piece)
		
	for piece in board.white:
		var instanced_piece = Piece.instance()
		instanced_piece.type = piece.type
		instanced_piece.color = Constants.PLAYER.white
		instanced_piece.board_position = Vector2(piece.position[0], piece.position[1])
		$Board/Pieces.add_child(instanced_piece)
	
func snap_pieces_position(piece = null):
	var pieces
	if piece == null:
		pieces = $Board/Pieces.get_children()
	else: 
		pieces = [piece]
	
	# TODO: make this function with different board sizes to allow for zoom and other resolutions
	for piece in pieces:
		var cell_center = Vector2(piece.sprite_region_size / 2, piece.sprite_region_size / 2)
		var real_position = piece.scale * (piece.board_position * piece.sprite_region_size + cell_center)
		piece.position = real_position
