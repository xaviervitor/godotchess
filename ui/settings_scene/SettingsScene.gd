extends Control

onready var board = get_tree().get_root().get_node("Game/Board")
onready var pieces = get_tree().get_root().get_node("Game/Board/Pieces")

var path_to_board_textures = "res://assets/textures/chessboard/"
var path_to_piece_textures = "res://assets/textures/chesspieces/"

func _ready():
	# warning-ignore:return_value_discarded
	$SettingsPopup/ConfirmButton.connect("button_up", self, "_on_ConfirmButton_button_up")
	# warning-ignore:return_value_discarded
	$SettingsPopup/CancelButton.connect("button_up", self, "_on_CancelButton_button_up")
	
	var board_textures = list_files_in_directory(path_to_board_textures)
	var idx = 0
	for board_texture in board_textures:
		var board_texture_name = get_texture_name(board_texture)
		$SettingsPopup/BoardsOptionButton.add_item(board_texture_name, idx)
		$SettingsPopup/BoardsOptionButton.set_item_metadata(idx, board_texture)
		if (path_to_board_textures + board_texture == board.get_node("Sprite").texture.resource_path):
			$SettingsPopup/BoardsOptionButton.select(idx)
		idx += 1
	
	var piece_textures = list_files_in_directory(path_to_piece_textures)
	idx = 0
	for piece_texture in piece_textures:
		var piece_texture_name = get_texture_name(piece_texture)
		$SettingsPopup/PiecesOptionButton.add_item(piece_texture_name, idx)
		$SettingsPopup/PiecesOptionButton.set_item_metadata(idx, piece_texture)
		if (path_to_piece_textures + piece_texture == pieces.get_node("Piece").get_node("Sprite").texture.resource_path):
			$SettingsPopup/PiecesOptionButton.select(idx)
		idx += 1
	$SettingsPopup/SoundCheckBox.pressed = Global.sounds_enabled

func _on_ConfirmButton_button_up():
	var board_texture = load(path_to_board_textures + $SettingsPopup/BoardsOptionButton.get_selected_metadata())
	var piece_texture = load(path_to_piece_textures + $SettingsPopup/PiecesOptionButton.get_selected_metadata())
	
	board.get_node("Sprite").set_texture(board_texture)
	for piece in pieces.get_children():
		piece.get_node("Sprite").set_texture(piece_texture)
	
	Global.sounds_enabled = $SettingsPopup/SoundCheckBox.pressed
	
	queue_free()

func _on_CancelButton_button_up():
	queue_free()

func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and not file.ends_with(".import"):
			files.append("" + file)
	dir.list_dir_end()
	return files

func get_texture_name(texture):
	return texture.split(".")[0].split("_")[1]
