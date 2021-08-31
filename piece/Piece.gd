extends Node2D

class_name Piece

var sprite_size = 256
var type = Constants.PIECE_TYPE.pawn
var color = Constants.PLAYER.black
var board_coordinates : Vector2

func _ready() -> void:
	set_piece_sprite()

func set_piece_sprite() -> void:
	var color_modifier = sprite_size if color == Constants.PLAYER.white  else 0
	var region_rect
	match type:
		Constants.PIECE_TYPE.pawn:
			region_rect = Rect2(sprite_size * 0, color_modifier, sprite_size, sprite_size)
		Constants.PIECE_TYPE.horse:
			region_rect = Rect2(sprite_size * 2, color_modifier, sprite_size, sprite_size)
		Constants.PIECE_TYPE.king:
			region_rect = Rect2(sprite_size * 5, color_modifier, sprite_size, sprite_size)
		Constants.PIECE_TYPE.tower:
			region_rect = Rect2(sprite_size * 1, color_modifier, sprite_size, sprite_size)
		Constants.PIECE_TYPE.bishop:
			region_rect = Rect2(sprite_size * 3, color_modifier, sprite_size, sprite_size)
		Constants.PIECE_TYPE.queen:
			region_rect = Rect2(sprite_size * 4, color_modifier, sprite_size, sprite_size)
	$Sprite.region_rect = region_rect

func drag_to(_position) -> void:
	self.position = _position

func get_possible_moves(board) -> Array:
	match type:
		Constants.PIECE_TYPE.pawn:
			return get_pawn_moves(board)
		Constants.PIECE_TYPE.tower:
			return get_tower_moves(board)
		Constants.PIECE_TYPE.horse:
			return get_horse_moves(board)
		Constants.PIECE_TYPE.bishop:
			return get_bishop_moves(board)
		Constants.PIECE_TYPE.queen:
			return get_queen_moves(board)
		Constants.PIECE_TYPE.king:
			return get_king_moves(board)
	return []

func get_pawn_moves(board) -> Array:
	var moves = []
	# single
	var standard_move = Vector2(0, 1) if color == Constants.PLAYER.white else Vector2(0, -1)
	if is_valid_pawn(standard_move, board):
		moves.push_back(board_coordinates + standard_move)
	# double
	if (color == Constants.PLAYER.black and board_coordinates.y == 6) or (color == Constants.PLAYER.white and board_coordinates.y == 1):
		var double_move = Vector2(0, 2) if color == Constants.PLAYER.white else Vector2(0, -2)
		if is_valid_pawn(standard_move, board) and is_valid_pawn(double_move, board):
			moves.push_back(board_coordinates + double_move)
	# capturing
	moves += get_pawn_captures(board)
	
	# en passant
#	var en_passant_moves = [Vector2(1, 0), Vector2(-1, 0)] if color == Constants.PLAYER.white else [Vector2(-1, 0), Vector2(1, 0)]
#	for en_passant_move in en_passant_moves:
#		if is_pawn_capture(en_passant_move, board):
#			moves.push_back(board_coordinates + en_passant_move)
	
	return moves

func get_pawn_captures(board) -> Array:
	var moves = []
	
	var captures = [Vector2(1, 1), Vector2(-1, 1)] if color == Constants.PLAYER.white else [Vector2(-1, -1), Vector2(1, -1)]
	for move in captures:
		move = board_coordinates + move
		if Global.is_inside_board(move):
			var piece = board[move.x][move.y]
			if piece != null and piece.color != self.color:
				moves.append(move)
			
#			var en_passant_move = move + (Vector2(0, -1) if color == Constants.PLAYER.white else Vector2(0, 1))
#			var victim = board[en_passant_move.x][en_passant_move.y]
#			if victim:
#				moves.append(move)
	
	return moves

func is_valid_pawn(move: Vector2, board) -> bool:
	move = board_coordinates + move
	
	if not Global.is_inside_board(move):
		return false
	
	# any piece is in the square
	if board[move.x][move.y] != null:
		return false
	
	return true

func get_horse_moves(board) -> Array:
	var maybe_moves = []
	maybe_moves.push_back(Vector2(2, 1))
	maybe_moves.push_back(Vector2(2, -1))
	maybe_moves.push_back(Vector2(-2, 1))
	maybe_moves.push_back(Vector2(-2, -1))
	maybe_moves.push_back(Vector2(1, 2))
	maybe_moves.push_back(Vector2(1, -2))
	maybe_moves.push_back(Vector2(-1, 2))
	maybe_moves.push_back(Vector2(-1, -2))

	var moves = []
	for maybe_move in maybe_moves:
		if is_valid_placing(maybe_move, board):
			moves.push_back(board_coordinates + maybe_move)
	return moves
	
func get_king_moves(board) -> Array:
	var maybe_moves = []
	maybe_moves.push_back(Vector2(0, 1))
	maybe_moves.push_back(Vector2(0, -1))
	maybe_moves.push_back(Vector2(1, 0))
	maybe_moves.push_back(Vector2(-1, 0))
	maybe_moves.push_back(Vector2(1, 1))
	maybe_moves.push_back(Vector2(1, -1))
	maybe_moves.push_back(Vector2(-1, 1))
	maybe_moves.push_back(Vector2(-1, -1))

	var moves = []
	for maybe_move in maybe_moves:
		if is_valid_placing(maybe_move, board):
			moves.push_back(board_coordinates + maybe_move)
	
	# se um rei não se mexeu, e na mesma linha dele tem alguma
	# torre que também não se mexeu, castling
	
	return moves

func get_tower_moves(board) -> Array:
	var directions = []
	directions.append(Vector2(0, 1))
	directions.append(Vector2(0, -1))
	directions.append(Vector2(1, 0))
	directions.append(Vector2(-1, 0))
	
	return get_sliding_moves(directions, board)

func get_bishop_moves(board) -> Array:
	var directions = []
	directions.append(Vector2(1, 1))
	directions.append(Vector2(1, -1))
	directions.append(Vector2(-1, -1))
	directions.append(Vector2(-1, 1))
	
	return get_sliding_moves(directions, board)

func get_queen_moves(board) -> Array:
	var directions = []
	directions.append(Vector2(0, 1))
	directions.append(Vector2(0, -1))
	directions.append(Vector2(1, 0))
	directions.append(Vector2(-1, 0))
	directions.append(Vector2(1, 1))
	directions.append(Vector2(1, -1))
	directions.append(Vector2(-1, -1))
	directions.append(Vector2(-1, 1))
	
	return get_sliding_moves(directions, board)


func is_valid_placing(move: Vector2, board) -> bool:
	move = board_coordinates + move
	
	if not Global.is_inside_board(move):
		return false
	
	# a piece of the same player is in the square
	var piece = board[move.x][move.y]
	if piece != null:
		if piece.color == self.color:
			return false
		else: 
			return true
	
	return true

func get_sliding_moves(directions: Array, board) -> Array:
	var moves = []
	for direction in directions:
		var i = 1
		while(true):
			var move = direction * i
			move = board_coordinates + move
			if not Global.is_inside_board(move):
				break
			
			var piece = board[move.x][move.y]
			if piece != null:
				if piece.color != self.color:
					moves.append(move)
				break
			
			moves.append(move)
			i += 1
		
	
	return moves
