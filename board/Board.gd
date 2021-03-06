extends Node2D

signal piece_moved
signal pawn_promoted(Piece)
signal checkmate(player)
signal stalemate(player)

export (PackedScene) var Piece
const Move = preload("res://move/Move.gd")
var dot_texture = preload("res://assets/misc/dot.png")

var board_matrix = [
	[null, null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null, null],
]
var en_passant_piece : Piece = null
var held_piece : Piece = null
var held_piece_moves = null

func _input(_event) -> void:
	if Input.is_action_just_pressed("click"):
		var mouse_position = get_local_mouse_position()
		var clicked_board_coordinates = get_board_coordinates(mouse_position)
		
		if Global.is_inside_board(clicked_board_coordinates):
			held_piece = board_matrix[clicked_board_coordinates.x][clicked_board_coordinates.y]
			if held_piece != null: 
				if (Global.player_turn != held_piece.color):
					held_piece = null
				else:
					held_piece_moves = held_piece.get_legal_moves(board_matrix, en_passant_piece)
					highlight_moves(held_piece_moves)
		return

	if held_piece:
		var mouse_position = get_local_mouse_position()
		var clicked_board_coordinates = get_board_coordinates(mouse_position)
		
		if Input.is_action_pressed("click"):
			held_piece.drag_to(mouse_position)

		if Input.is_action_just_released("click"):
			clear_highlighted_moves()
			for move in held_piece_moves:
				if move.destination == clicked_board_coordinates:
					make_play(move)
			snap_pieces_position([held_piece])
			held_piece = null
			held_piece_moves = null

func snap_pieces_position(pieces) -> void:
	for piece in pieces:
		piece.position = get_world_coordinates(piece.board_coordinates)

func get_board_coordinates(world_coordinates) -> Vector2:
	return $TileMap.world_to_map(world_coordinates) * Vector2(1, -1) + Vector2(4, 3)

func get_tilemap_coordinates(board_coordinates) -> Vector2:
	return board_coordinates * Vector2(1, -1) + Vector2(4, 3)

func get_world_coordinates(board_coordinates):
	return $TileMap.map_to_world( \
			# inverts the position in the y axis
			Vector2(board_coordinates.x, -board_coordinates.y) \
			# adjusts the board coordinates to match the tilemap coordinates
			+ Vector2(-4, 3) \
			# centers the piece inside the cell 
			) + Vector2($Sprite.texture.get_size() / 16)

func highlight_moves(possible_moves):
	for move in possible_moves:
		var highlight = Sprite.new()
		highlight.position = get_world_coordinates(move.destination)
		highlight.texture = dot_texture
		highlight.modulate = Color(0, 0, 0, 0.25)
		if Global.is_inside_board(move.destination) and (board_matrix[move.destination.x][move.destination.y] != null or move.type == Constants.MOVE_TYPE.EN_PASSANT):
			highlight.scale = highlight.scale * 3
		$Highlights.add_child(highlight)

func clear_highlighted_moves():
	for highlight in $Highlights.get_children():
		highlight.queue_free()

func add_piece_to_board(color, type, piece_position) -> Piece:
	var instanced_piece = Piece.instance()
	instanced_piece.type = type
	instanced_piece.color = color
	instanced_piece.board_coordinates = piece_position
	board_matrix[piece_position.x][piece_position.y] = instanced_piece
	$Pieces.add_child(instanced_piece)
	return instanced_piece
	
func make_play(move):
	var victim = board_matrix[move.destination.x][move.destination.y]
	if victim:
		victim.queue_free()
		victim.free()
	
	move_castling_tower(move)
	handle_en_passant(move)
	handle_promotion(move)
	move_piece(move)
	emit_signal("piece_moved")

func move_piece(move):
	move.piece.increase_move_count()
	board_matrix[move.piece.board_coordinates.x][move.piece.board_coordinates.y] = null
	board_matrix[move.destination.x][move.destination.y] = move.piece
	move.piece.board_coordinates = move.destination
	Global.play_sound($MoveSoundPlayer)

func move_castling_tower(move):
	if (move.type != Constants.MOVE_TYPE.CASTLING):
		return
	var king_destination = move.destination
	var king_move = move.piece.board_coordinates - king_destination
	var king_move_direction = king_move.normalized() * -1
	var castling_tower = move.affected_piece
	var tower_move = Move.new(castling_tower, Constants.MOVE_TYPE.CASTLING, Vector2(king_destination.x + king_move_direction.x * -1, king_destination.y))
	move_piece(tower_move)
	Global.play_sound($CastlingSoundPlayer)
	snap_pieces_position([castling_tower])

func handle_en_passant(move):
	if move.type == Constants.MOVE_TYPE.EN_PASSANT:
		board_matrix[en_passant_piece.board_coordinates.x][en_passant_piece.board_coordinates.y] = null
		en_passant_piece.queue_free()
		en_passant_piece.free()
	
	en_passant_piece = move.piece if move.type == Constants.MOVE_TYPE.DOUBLE else null

func handle_promotion(move):
	if move.piece.type == Constants.PIECE_TYPE.pawn and (move.destination.y == 0 or move.destination.y == 7):
		emit_signal("pawn_promoted", move.piece)

func game_over():
	var moves = get_all_legal_moves(Global.player_turn)
	var check = check()
	if len(moves) == 0:
		if (check):
			emit_signal("checkmate")
		else:
			emit_signal("stalemate")
		return true
	return false

func check():
	var moves = get_all_legal_moves(Global.other_player_turn)
	var king_position = get_king(Global.player_turn, board_matrix).board_coordinates
	var check = false
	for move in moves:
		if move.destination == king_position:
			check = true
	return check

func get_all_legal_moves(player):
	var all_moves = []
	for row in board_matrix:
		for piece in row:
			if piece != null and piece.color == player:
				all_moves += piece.get_legal_moves(board_matrix, en_passant_piece)
	return all_moves

# same function as piece.get_king(). really should clean this up 
func get_king(player, board):
	var king = null
	for row in board:
		for piece in row:
			if piece != null and piece.color == player and piece.type == Constants.PIECE_TYPE.king:
				king = piece
	return king
