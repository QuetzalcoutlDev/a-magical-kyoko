extends AudioStreamPlayer2D

const main_theme = preload("res://assets/sounds/menuTheme.ogg")
const game_theme = preload("res://assets/sounds/gameTheme.ogg")
const lose_sound = preload("res://assets/sounds/LoseSound.ogg")

func play_music(m:AudioStream, b:String = "Master", volume:float = 0.0):
	if stream == m:
		return
	stream = m
	volume_db = volume
	bus = b
	play()

func play_main_theme():
	play_music(main_theme, "music")

func play_game_theme():
	play_music(game_theme, "music")

func play_lose_sound():
	play_music(lose_sound, "music")
