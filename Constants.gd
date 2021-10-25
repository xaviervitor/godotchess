extends Node

enum PLAYER {
	white,
	black
}

enum GAME_MODE {
	singleplayer,
	local_multiplayer
}

enum MOVE_TYPE {
	SINGLE,
	DOUBLE,
	EN_PASSANT,
	CASTLING
}

enum PIECE_TYPE {
	pawn,
	tower,
	horse,
	bishop,
	queen,
	king
}
