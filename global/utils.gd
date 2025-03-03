extends Node


const SAVE_PATH = "res://savegame.bin"


func save_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data: Dictionary = {
		"player_hp": game.player_hp,
		"gold": game.gold,
	}
	var jstr = JSON.stringify(data)
	file.store_line(jstr)

func load_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if FileAccess.file_exists(SAVE_PATH) == true:
		if not file.eof_reached():
			var current_line = JSON.parse_string(file.get_line())
			if current_line:
				game.player_hp = current_line["player_hp"]
				game.gold = current_line["gold"]
