extends Node2D

func _ready() -> void:
	$SC/e/fullscreen/check.set_pressed_no_signal(GLOBAL.game_settings["fullscreen"])
	if not GLOBAL.game_settings["fps"]:
		$SC/e/fps/check.set_pressed_no_signal(GLOBAL.game_settings["fps"])

func _on_back_pressed() -> void:
	GLOBAL.SaveGameSettings()
	SceneManager.change_scene("res://src/main_menu.tscn", {"speed": 4})

func _on_fps_check_toggled(toggled_on: bool) -> void:
	GLOBAL.game_settings["fps"] = toggled_on
	print("Valor del check FPS cambiado, ahora es: " + str(toggled_on))

func _on_full_screen_check_toggled(toggled_on: bool) -> void:
	GLOBAL.game_settings["fullscreen"] = toggled_on
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	print("Valor del check FPS cambiado, ahora es: " + str(toggled_on))

func _on_language_popup__index_pressed(index: int) -> void:
	print("Opción seleccionada = " + $"SC/e/languages/m/>>>>>>>".get_item_text(index))
	var languages = ["es", "en"]
	GLOBAL.game_settings["language"] = languages[index]
	GLOBAL.game_settings["language_is_change"] = true
	TranslationServer.set_locale(languages[index])
