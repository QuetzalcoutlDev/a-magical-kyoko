extends Node2D

func _ready() -> void:
	$s.play()
	AudioPlayer.play_lose_sound()
	if GLOBAL.highscore > GLOBAL.game_data["score"]:
		GLOBAL.game_data["score"] = GLOBAL.highscore
	
	$scoresTXT/score/n.text = str(GLOBAL.highscore)
	$scoresTXT/highscore/n.text = str(GLOBAL.game_data["score"])
	
func _on_restart_pressed() -> void:
	GLOBAL.SaveGameData()
	SceneManager.change_scene("res://src/game.tscn", { "speed": 4, "pattern_leave": "squares"})

func _on_to_menu_pressed() -> void:
	GLOBAL.SaveGameData()
	SceneManager.change_scene("res://src/main_menu.tscn")
