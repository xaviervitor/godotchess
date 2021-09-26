extends Node2D

signal piece_moved

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

var en_passant_coordinate = Vector2.ZERO

var held_piece : Piece = null

func _input(_event) -> void:
	if Input.is_action_just_pressed("click"):
		var mouse_position = get_local_mouse_position()
		var clicked_board_coordinates = get_board_coordinates(mouse_position)
		
		if Global.is_inside_board(clicked_board_coordinates):
			held_piece = board_matrix[clicked_board_coordinates.x][clicked_board_coordinates.y]
			if held_piece != null: 
				if (Global.get_player_turn() != held_piece.color):
					held_piece = null
				else: 
					highlight_moves(held_piece.get_possible_moves(board_matrix))
		return

	if held_piece:
		var mouse_position = get_local_mouse_position()
		var clicked_board_coordinates = get_board_coordinates(mouse_position)
		
		if Input.is_action_pressed("click"):
			held_piece.drag_to(mouse_position)

		if Input.is_action_just_released("click"):
			clear_highlighted_moves()
			if clicked_board_coordinates in held_piece.get_possible_moves(board_matrix):
				move_piece(held_piece, clicked_board_coordinates)
			snap_pieces_position([held_piece])
			held_piece = null

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
			) + Vector2($BoardSprite.texture.get_size() / 16)

func highlight_moves(possible_moves):
	for move in possible_moves:
		var highlight = Sprite.new()
		highlight.position = get_world_coordinates(move)
		highlight.texture = load("res://assets/dot.png")
		highlight.modulate = Color(0, 0, 0, 0.25)
		if board_matrix[move.x][move.y] != null:
			highlight.scale = highlight.scale * 3
		$Highlights.add_child(highlight)

func clear_highlighted_moves():
	for highlight in $Highlights.get_children():
		highlight.queue_free()

func move_piece(piece, destination, castling_tower = null):
	var victim = board_matrix[destination.x][destination.y]
	if victim:
		victim.queue_free()
		victim.free()
		
	piece.increase_move_count()
	if (castling_tower):
		board_matrix[castling_tower.board_coordinates.x][castling_tower.board_coordinates.y] = null
		board_matrix[2 if castling_tower.board_coordinates.x == 0 else 5][castling_tower.board_coordinates.y] = castling_tower

	board_matrix[piece.board_coordinates.x][piece.board_coordinates.y] = null
	board_matrix[destination.x][destination.y] = piece
	
	piece.board_coordinates = destination
	
	emit_signal("piece_moved")
