extends Node

var standard_board = {
	"to_move": "white",
	"white": [
		{"type": Constants.PIECE_TYPE.pawn, "position": [0, 1]},
		{"type": Constants.PIECE_TYPE.pawn, "position": [1, 1]},
		{"type": Constants.PIECE_TYPE.pawn, "position": [2, 1]},
		{"type": Constants.PIECE_TYPE.pawn, "position": [3, 1]},
		{"type": Constants.PIECE_TYPE.pawn, "position": [4, 1]},
		{"type": Constants.PIECE_TYPE.pawn, "position": [5, 1]},
		{"type": Constants.PIECE_TYPE.pawn, "position": [6, 1]},
		{"type": Constants.PIECE_TYPE.pawn, "position": [7, 1]},
		{"type": Constants.PIECE_TYPE.tower, "position": [0, 0]},
		{"type": Constants.PIECE_TYPE.horse, "position": [1, 0]},
		{"type": Constants.PIECE_TYPE.bishop, "position": [2, 0]},
		{"type": Constants.PIECE_TYPE.queen, "position": [3, 0]},
		{"type": Constants.PIECE_TYPE.king, "position": [4, 0]},
		{"type": Constants.PIECE_TYPE.bishop, "position": [5, 0]},
		{"type": Constants.PIECE_TYPE.horse, "position": [6, 0]},
		{"type": Constants.PIECE_TYPE.tower, "position": [7, 0]},
	],
	"black": [
		{"type": Constants.PIECE_TYPE.pawn, "position": [0, 6]},
		{"type": Constants.PIECE_TYPE.pawn, "position": [1, 6]},
		{"type": Constants.PIECE_TYPE.pawn, "position": [2, 6]},
		{"type": Constants.PIECE_TYPE.pawn, "position": [3, 6]},
		{"type": Constants.PIECE_TYPE.pawn, "position": [4, 6]},
		{"type": Constants.PIECE_TYPE.pawn, "position": [5, 6]},
		{"type": Constants.PIECE_TYPE.pawn, "position": [6, 6]},
		{"type": Constants.PIECE_TYPE.pawn, "position": [7, 6]},
		{"type": Constants.PIECE_TYPE.tower, "position": [0, 7]},
		{"type": Constants.PIECE_TYPE.horse, "position": [1, 7]},
		{"type": Constants.PIECE_TYPE.bishop, "position": [2, 7]},
		{"type": Constants.PIECE_TYPE.queen, "position": [3, 7]},
		{"type": Constants.PIECE_TYPE.king, "position": [4, 7]},
		{"type": Constants.PIECE_TYPE.bishop, "position": [5, 7]},
		{"type": Constants.PIECE_TYPE.horse, "position": [6, 7]},
		{"type": Constants.PIECE_TYPE.tower, "position": [7, 7]},
	]
}

var castling_board = {
	"to_move": "white",
	"white": [
		{"type": Constants.PIECE_TYPE.tower, "position": [0, 0]},
		{"type": Constants.PIECE_TYPE.king, "position": [4, 0]},
		{"type": Constants.PIECE_TYPE.tower, "position": [7, 0]},
	],
	"black": [
		{"type": Constants.PIECE_TYPE.tower, "position": [0, 7]},
		{"type": Constants.PIECE_TYPE.king, "position": [4, 7]},
		{"type": Constants.PIECE_TYPE.tower, "position": [7, 7]},
	]
}

var en_passant_board = {
	"to_move": "black",
	"white": [
		{"type": Constants.PIECE_TYPE.pawn, "position": [0, 1]},
		{"type": Constants.PIECE_TYPE.pawn, "position": [1, 1]},
		{"type": Constants.PIECE_TYPE.pawn, "position": [2, 1]},
		{"type": Constants.PIECE_TYPE.pawn, "position": [3, 4]},
		{"type": Constants.PIECE_TYPE.pawn, "position": [4, 1]},
		{"type": Constants.PIECE_TYPE.pawn, "position": [5, 1]},
		{"type": Constants.PIECE_TYPE.pawn, "position": [6, 1]},
		{"type": Constants.PIECE_TYPE.pawn, "position": [7, 1]},
		{"type": Constants.PIECE_TYPE.tower, "position": [0, 0]},
		{"type": Constants.PIECE_TYPE.horse, "position": [1, 0]},
		{"type": Constants.PIECE_TYPE.bishop, "position": [2, 0]},
		{"type": Constants.PIECE_TYPE.queen, "position": [3, 0]},
		{"type": Constants.PIECE_TYPE.king, "position": [4, 0]},
		{"type": Constants.PIECE_TYPE.bishop, "position": [5, 0]},
		{"type": Constants.PIECE_TYPE.horse, "position": [6, 0]},
		{"type": Constants.PIECE_TYPE.tower, "position": [7, 0]},
	],
	"black": [
		{"type": Constants.PIECE_TYPE.pawn, "position": [0, 6]},
		{"type": Constants.PIECE_TYPE.pawn, "position": [1, 6]},
		{"type": Constants.PIECE_TYPE.pawn, "position": [2, 6]},
		{"type": Constants.PIECE_TYPE.pawn, "position": [3, 6]},
		{"type": Constants.PIECE_TYPE.pawn, "position": [4, 6]},
		{"type": Constants.PIECE_TYPE.pawn, "position": [5, 6]},
		{"type": Constants.PIECE_TYPE.pawn, "position": [6, 6]},
		{"type": Constants.PIECE_TYPE.pawn, "position": [7, 6]},
		{"type": Constants.PIECE_TYPE.tower, "position": [0, 7]},
		{"type": Constants.PIECE_TYPE.horse, "position": [1, 7]},
		{"type": Constants.PIECE_TYPE.bishop, "position": [2, 7]},
		{"type": Constants.PIECE_TYPE.queen, "position": [3, 7]},
		{"type": Constants.PIECE_TYPE.king, "position": [4, 7]},
		{"type": Constants.PIECE_TYPE.bishop, "position": [5, 7]},
		{"type": Constants.PIECE_TYPE.horse, "position": [6, 7]},
		{"type": Constants.PIECE_TYPE.tower, "position": [7, 7]},
	]
}

var promotion_board = {
	"to_move": "white",
	"white": [
		{"type": Constants.PIECE_TYPE.pawn, "position": [0, 6]},
		{"type": Constants.PIECE_TYPE.tower, "position": [3, 0]},
		{"type": Constants.PIECE_TYPE.king, "position": [4, 0]},
	],
	"black": [
		{"type": Constants.PIECE_TYPE.pawn, "position": [0, 1]},
		{"type": Constants.PIECE_TYPE.tower, "position": [3, 7]},
		{"type": Constants.PIECE_TYPE.king, "position": [4, 7]},
	]
}

var check_board = {
	"to_move": "black",
	"white": [
		{"type": Constants.PIECE_TYPE.queen, "position": [0, 6]},
		{"type": Constants.PIECE_TYPE.tower, "position": [1, 5]},
		{"type": Constants.PIECE_TYPE.king, "position": [4, 0]},
	],
	"black": [
		{"type": Constants.PIECE_TYPE.king, "position": [4, 7]},
	]
}

var stale_board = {
	"to_move": "black",
	"white": [
		{"type": Constants.PIECE_TYPE.tower, "position": [0, 7]},
		{"type": Constants.PIECE_TYPE.tower, "position": [0, 5]},
		{"type": Constants.PIECE_TYPE.tower, "position": [5, 0]},
		{"type": Constants.PIECE_TYPE.tower, "position": [2, 0]},
		{"type": Constants.PIECE_TYPE.king, "position": [4, 0]},
	],
	"black": [
		{"type": Constants.PIECE_TYPE.king, "position": [3, 6]},
	]
}
