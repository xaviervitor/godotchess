extends Node

export (PackedScene) var Piece

func _ready():
	set_board()
	snap_pieces_position()

func set_board(board = Constants.standard_board):
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
	
func snap_pieces_position(pieces = $Board/Pieces.get_children()):
	for piece in pieces:
		var world_position = $Board/TileMap.map_to_world( \
				# inverts the position in the y axis
				Vector2(piece.board_position.x, -piece.board_position.y - 1) \
				# adjusts the board coordinates to match the tilemap coordinates
				+ Vector2(-4, 4) \
				# centers the piece inside the cell 
				) + Vector2($Board/BoardSprite.texture.get_size() / 16)
		piece.position = world_position
