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
		Constants.PIECE_TYPE.tower:
			region_rect = Rect2(sprite_size * 1, color_modifier, sprite_size, sprite_size)
		Constants.PIECE_TYPE.horse:
			region_rect = Rect2(sprite_size * 2, color_modifier, sprite_size, sprite_size)
		Constants.PIECE_TYPE.bishop:
			region_rect = Rect2(sprite_size * 3, color_modifier, sprite_size, sprite_size)
		Constants.PIECE_TYPE.queen:
			region_rect = Rect2(sprite_size * 4, color_modifier, sprite_size, sprite_size)
		Constants.PIECE_TYPE.king:
			region_rect = Rect2(sprite_size * 5, color_modifier, sprite_size, sprite_size)
	$Sprite.region_rect = region_rect

func drag_to(_position) -> void:
	self.position = _position
