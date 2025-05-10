extends CanvasLayer

func _process(_delta: float) -> void:
	$txt.text = "FPS: " + str(Engine.get_frames_per_second())
	visible = GLOBAL.game_settings["fps"]
