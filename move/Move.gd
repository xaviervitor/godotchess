extends Object

var piece
var type
var destination
var affected_piece

func _init(_piece, _type, _destination, _affected_piece = null):
	piece = _piece
	type = _type
	destination = _destination
	affected_piece = _affected_piece
