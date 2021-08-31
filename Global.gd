extends Node

func is_inside_board(coordinate):
	if coordinate.x < 0 or coordinate.x > 7 or coordinate.y < 0 or coordinate.y > 7:
		return false
	return true
