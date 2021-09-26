extends Node

var current_player = Constants.PLAYER.white

func get_player_turn():
	return current_player

func swap_player_turn():
	if current_player == Constants.PLAYER.white:
		current_player = Constants.PLAYER.black
	elif current_player == Constants.PLAYER.black:
		current_player = Constants.PLAYER.white

func is_inside_board(coordinate):
	if coordinate.x < 0 or coordinate.x > 7 or coordinate.y < 0 or coordinate.y > 7:
		return false
	return true
