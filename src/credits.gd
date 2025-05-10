extends Node2D

func _on_back_pressed() -> void:
	SceneManager.change_scene("res://src/main_menu.tscn", {"speed": 4})
