extends CanvasLayer

func _on_continue_pressed() -> void:
	get_tree().paused = false
	queue_free()

func _on_to_menu_pressed() -> void:
	get_tree().paused = false
	SceneManager.change_scene("res://src/main_menu.tscn", {"speed": 4})
	queue_free()
