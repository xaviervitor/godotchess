extends Node

var player_turn = Constants.PLAYER.white

func swap_player_turn():
	if player_turn == Constants.PLAYER.white:
		player_turn = Constants.PLAYER.black
	elif player_turn == Constants.PLAYER.black:
		player_turn = Constants.PLAYER.white

func is_inside_board(coordinate):
	if coordinate.x < 0 or coordinate.x > 7 or coordinate.y < 0 or coordinate.y > 7:
		return false
	return true
