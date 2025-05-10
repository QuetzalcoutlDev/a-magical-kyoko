extends Node2D

func _ready() -> void:
	if OS.get_name() == "Android" or OS.get_name() == "Web":
		$buttons/exit.visible = false
		$buttons/s3.visible = false
	var version = ProjectSettings.get_setting("application/config/version")
	$v.text = "v" + version + "-" + OS.get_name()
	
	AudioPlayer.play_main_theme()
	
func _on_start_pressed() -> void:
	SceneManager.change_scene("res://src/game.tscn", { "speed": 4, "pattern_leave": "squares"})
func _on_settings_pressed() -> void:
	SceneManager.change_scene("res://src/config.tscn", {"speed": 4})
func _on_credits_pressed() -> void:
	SceneManager.change_scene("res://src/credits.tscn", {"speed": 4})
func _on_exit_pressed() -> void:
	get_tree().quit()
