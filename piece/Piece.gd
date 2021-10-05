extends Node2D

class_name Piece

const Move = preload("res://move/Move.gd")

var sprite_size = 256
var type = Constants.PIECE_TYPE.pawn
var color = Constants.PLAYER.black
var board_coordinates : Vector2
var move_count = 0

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

func promote():
	type = Constants.PIECE_TYPE.queen
	set_piece_sprite()

func drag_to(_position) -> void:
	self.position = _position

func increase_move_count():
	move_count += 1

func get_legal_moves(board, en_passant_piece) -> Array:
	return filter_king_safe_moves(get_pseudo_moves(board, en_passant_piece), board, en_passant_piece)

func get_pseudo_moves(board, en_passant_piece = null) -> Array:
	match type:
		Constants.PIECE_TYPE.pawn:
			return get_pawn_moves(board, en_passant_piece)
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
		_:
			return []

func get_pawn_moves(board, en_passant_piece) -> Array:
	var moves = []
	# single
	var standard_move = Vector2(0, 1) if color == Constants.PLAYER.white else Vector2(0, -1)
	if is_valid_pawn(standard_move, board):
		moves.push_back(Move.new(self, Constants.MOVE_TYPE.SINGLE, board_coordinates + standard_move))
	# double
	if self.move_count == 0:
		var double_move = Vector2(0, 2) if color == Constants.PLAYER.white else Vector2(0, -2)
		if is_valid_pawn(standard_move, board) and is_valid_pawn(double_move, board):
			moves.push_back(Move.new(self, Constants.MOVE_TYPE.DOUBLE, board_coordinates + double_move))
	# capturing
	moves += get_pawn_captures(board, en_passant_piece)
	
	return moves

func get_pawn_captures(board, en_passant_piece) -> Array:
	var moves = []
	
	var captures = [Vector2(1, 1), Vector2(-1, 1)] if color == Constants.PLAYER.white else [Vector2(-1, -1), Vector2(1, -1)]
	for move in captures:
		move = board_coordinates + move
		if Global.is_inside_board(move):
			var piece = board[move.x][move.y]
			if piece != null and piece.color != self.color:
				moves.append(Move.new(self, Constants.MOVE_TYPE.SINGLE, move))

	var en_passant_moves = [Vector2(1, 1), Vector2(-1, 1)] if color == Constants.PLAYER.white else [Vector2(-1, -1), Vector2(1, -1)]
	for move in en_passant_moves:
		move = board_coordinates + move
		if Global.is_inside_board(move):
			var victim = board[move.x][board_coordinates.y]
			if victim != null and victim == en_passant_piece:
				moves.append(Move.new(self, Constants.MOVE_TYPE.EN_PASSANT, move, victim))
	return moves

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
			moves.push_back(Move.new(self, Constants.MOVE_TYPE.SINGLE, board_coordinates + maybe_move))
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
			moves.push_back(Move.new(self, Constants.MOVE_TYPE.SINGLE, board_coordinates + maybe_move))
	
	moves += get_castling_moves(board)
	
	return moves

func get_castling_moves(board) -> Array:
	var moves = []
	
	if move_count != 0:
		return moves

	var tower_left = board[0][board_coordinates.y]
	var tower_right = board[7][board_coordinates.y]
	
	if tower_left != null && board[1][board_coordinates.y] == null && board[2][board_coordinates.y] == null && board[3][board_coordinates.y] == null \
		&& tower_left.type == Constants.PIECE_TYPE.tower && tower_left.move_count == 0:
			var maybe_move = Vector2(-2, 0)
			if is_valid_placing(maybe_move, board):
				moves.push_back(Move.new(self, Constants.MOVE_TYPE.CASTLING, board_coordinates + maybe_move, tower_left))

	if tower_right != null && board[5][board_coordinates.y] == null && board[6][board_coordinates.y] == null \
		&& tower_right.type == Constants.PIECE_TYPE.tower && tower_right.move_count == 0:
			var maybe_move = Vector2(2, 0)
			if is_valid_placing(maybe_move, board):
				moves.push_back(Move.new(self, Constants.MOVE_TYPE.CASTLING, board_coordinates + maybe_move, tower_right))
			
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
					moves.append(Move.new(self, Constants.MOVE_TYPE.SINGLE, move))
				break
			
			moves.append(Move.new(self, Constants.MOVE_TYPE.SINGLE, move))
			i += 1
	

	return moves
func is_valid_pawn(move: Vector2, board) -> bool:
	move = board_coordinates + move
	
	if not Global.is_inside_board(move):
		return false
	
	# any piece is in the square
	if board[move.x][move.y] != null:
		return false
	
	return true

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

func filter_king_safe_moves(moves, board, en_passant_piece):
	var moves_to_remove = []
	for index in len(moves):
		var move = moves[index]
		# test move
		var starting_position = move.piece.board_coordinates
		var actual_player_turn = Global.player_turn
		var captured_piece = test_move_piece(move, board)
		# check for invalid moves
		var test_player_turn = Global.player_turn
		for next_move in get_all_pseudo_moves(test_player_turn, board, en_passant_piece):
			var king = get_king(actual_player_turn, board)
			if (next_move.destination == king.board_coordinates):
				moves_to_remove.append(index)
				break
		# undo test move
		test_unmove_piece(Move.new(move.piece, Constants.MOVE_TYPE.SINGLE, starting_position), board, captured_piece)
	# remove from moves
	if moves_to_remove == []: 
		return moves
	moves_to_remove.invert()
	for index in moves_to_remove:
		moves.remove(index)
	return moves

func test_move_piece(move, board) -> Piece:
	board[move.piece.board_coordinates.x][move.piece.board_coordinates.y] = null
	var captured_piece = board[move.destination.x][move.destination.y]
	board[move.destination.x][move.destination.y] = move.piece
	move.piece.board_coordinates = move.destination
	Global.swap_player_turn()
	return captured_piece

func test_unmove_piece(move, board, captured_piece) -> void:
	board[move.piece.board_coordinates.x][move.piece.board_coordinates.y] = captured_piece
	board[move.destination.x][move.destination.y] = move.piece
	move.piece.board_coordinates = move.destination
	Global.swap_player_turn()
	
func get_king(player, board):
	var king = null
	for row in board:
		for piece in row:
			if piece != null and piece.color == player and piece.type == Constants.PIECE_TYPE.king:
				king = piece
	return king

func get_all_pseudo_moves(player, board, en_passant_piece):
	var all_moves = []
	for row in board:
		for piece in row:
			if piece != null and piece.color == player:
				all_moves += piece.get_pseudo_moves(board, en_passant_piece)
	return all_moves

func get_all_legal_moves(player, board, en_passant_piece):
	var all_moves = []
	for row in board:
		for piece in row:
			if piece != null and piece.color == player:
				all_moves += piece.get_legal_moves(board, en_passant_piece)
	return all_moves
