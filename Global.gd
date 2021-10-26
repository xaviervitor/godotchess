extends Node

var game_mode = Constants.GAME_MODE.local_multiplayer
var player_turn = Constants.PLAYER.white
var other_player_turn = Constants.PLAYER.black

var sounds_enabled = true

func set_player_turn(player):
	if player_turn != player:
		swap_player_turn()

func swap_player_turn():
	other_player_turn = player_turn
	if player_turn == Constants.PLAYER.white:
		player_turn = Constants.PLAYER.black
	elif player_turn == Constants.PLAYER.black:
		player_turn = Constants.PLAYER.white

func is_inside_board(coordinate):
	if coordinate.x < 0 or coordinate.x > 7 or coordinate.y < 0 or coordinate.y > 7:
		return false
	return true

func player_to_string(player):
	if player == Constants.PLAYER.white:
		return "white"
	elif player == Constants.PLAYER.black:
		return "black"

func play_sound(player_node):
	if sounds_enabled:
		player_node.play()
