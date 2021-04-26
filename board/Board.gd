extends Node2D

var piece_in_hand : Piece = null

func _input(_event) -> void:
	var mouse_position = get_local_mouse_position()
	var clicked_board_coordinates = get_board_coordinates(mouse_position)
	
	if Input.is_action_just_pressed("click"):
		for piece in $Pieces.get_children():
			if piece.board_coordinates == clicked_board_coordinates:
				piece_in_hand = piece

	if Input.is_action_just_released("click") and piece_in_hand != null:
			piece_in_hand.board_coordinates = clicked_board_coordinates
			snap_pieces_position([piece_in_hand])
			piece_in_hand = null

	if Input.is_action_pressed("click") and piece_in_hand != null:
			piece_in_hand.drag_to(mouse_position)

func snap_pieces_position(pieces) -> void:
	for piece in pieces:
		var world_position = $TileMap.map_to_world( \
				# inverts the position in the y axis
				Vector2(piece.board_coordinates.x, -piece.board_coordinates.y) \
				# adjusts the board coordinates to match the tilemap coordinates
				+ Vector2(-4, 3) \
				# centers the piece inside the cell 
				) + Vector2($BoardSprite.texture.get_size() / 16)
		piece.position = world_position

func get_board_coordinates(world_coordinates) -> Vector2:
	return $TileMap.world_to_map(world_coordinates) * Vector2(1, -1) + Vector2(4, 3)

func get_tilemap_coordinates(board_coordinates) -> Vector2:
	return board_coordinates * Vector2(1, -1) + Vector2(4, 3)

