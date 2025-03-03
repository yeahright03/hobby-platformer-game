extends Node2D


func _ready() -> void:
	utils.save_game()
	utils.load_game()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")
