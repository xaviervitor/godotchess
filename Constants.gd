extends Node

enum PLAYER {
	white,
	black
}

enum PIECE_TYPE {
	pawn,
	tower,
	horse,
	bishop,
	queen,
	king
}

var standard_board = {
	"white": [
		{"type": PIECE_TYPE.pawn, "position": [0, 1]},
		{"type": PIECE_TYPE.pawn, "position": [1, 1]},
		{"type": PIECE_TYPE.pawn, "position": [2, 1]},
		{"type": PIECE_TYPE.pawn, "position": [3, 1]},
		{"type": PIECE_TYPE.pawn, "position": [4, 1]},
		{"type": PIECE_TYPE.pawn, "position": [5, 1]},
		{"type": PIECE_TYPE.pawn, "position": [6, 1]},
		{"type": PIECE_TYPE.pawn, "position": [7, 1]},
		{"type": PIECE_TYPE.tower, "position": [0, 0]},
		{"type": PIECE_TYPE.horse, "position": [1, 0]},
		{"type": PIECE_TYPE.bishop, "position": [2, 0]},
		{"type": PIECE_TYPE.queen, "position": [3, 0]},
		{"type": PIECE_TYPE.king, "position": [4, 0]},
		{"type": PIECE_TYPE.bishop, "position": [5, 0]},
		{"type": PIECE_TYPE.horse, "position": [6, 0]},
		{"type": PIECE_TYPE.tower, "position": [7, 0]},
	],
	"black": [
		{"type": PIECE_TYPE.pawn, "position": [0, 6]},
		{"type": PIECE_TYPE.pawn, "position": [1, 6]},
		{"type": PIECE_TYPE.pawn, "position": [2, 6]},
		{"type": PIECE_TYPE.pawn, "position": [3, 6]},
		{"type": PIECE_TYPE.pawn, "position": [4, 6]},
		{"type": PIECE_TYPE.pawn, "position": [5, 6]},
		{"type": PIECE_TYPE.pawn, "position": [6, 6]},
		{"type": PIECE_TYPE.pawn, "position": [7, 6]},
		{"type": PIECE_TYPE.tower, "position": [0, 7]},
		{"type": PIECE_TYPE.horse, "position": [1, 7]},
		{"type": PIECE_TYPE.bishop, "position": [2, 7]},
		{"type": PIECE_TYPE.queen, "position": [3, 7]},
		{"type": PIECE_TYPE.king, "position": [4, 7]},
		{"type": PIECE_TYPE.bishop, "position": [5, 7]},
		{"type": PIECE_TYPE.horse, "position": [6, 7]},
		{"type": PIECE_TYPE.tower, "position": [7, 7]},
	]
}
