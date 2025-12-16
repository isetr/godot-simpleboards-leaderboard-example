extends Node2D

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")


func _on_leaderboard_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/LeaderboardPage.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_simple_boards_button_pressed() -> void:
	OS.shell_open("https://simpleboards.dev")
