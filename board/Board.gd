extends Node2D

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

var piece_in_hand : Piece = null

func _input(_event) -> void:
	var mouse_position = get_local_mouse_position()
	var clicked_board_coordinates = get_board_coordinates(mouse_position)
	if Input.is_action_just_pressed("click"):
		if not Global.is_inside_board(clicked_board_coordinates):
			return
		var clicked_piece = board_matrix[clicked_board_coordinates.x][clicked_board_coordinates.y]
		if clicked_piece != null:
			piece_in_hand = clicked_piece
			highlight_moves(piece_in_hand.get_possible_moves(board_matrix))

	if Input.is_action_just_released("click") and piece_in_hand != null:
		clear_highlighted_moves()
		if clicked_board_coordinates in piece_in_hand.get_possible_moves(board_matrix):
			var victim = board_matrix[piece_in_hand.board_coordinates.x][piece_in_hand.board_coordinates.y]
			if victim != null:
				board_matrix[piece_in_hand.board_coordinates.x][piece_in_hand.board_coordinates.y] = null
				
			board_matrix[clicked_board_coordinates.x][clicked_board_coordinates.y] = piece_in_hand
			piece_in_hand.board_coordinates = clicked_board_coordinates
		snap_pieces_position([piece_in_hand])
		piece_in_hand = null

	if Input.is_action_pressed("click") and piece_in_hand != null:
		piece_in_hand.drag_to(mouse_position)

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
		var sprite = Sprite.new()
		sprite.position = get_world_coordinates(move)
		sprite.texture = load("res://assets/dot.png")
		sprite.modulate = Color(0, 0, 0, 0.25)
		if board_matrix[move.x][move.y] != null:
			sprite.scale = sprite.scale * 3
		$Sprites.add_child(sprite)

func clear_highlighted_moves():
	for sprite in $Sprites.get_children():
		sprite.queue_free()
