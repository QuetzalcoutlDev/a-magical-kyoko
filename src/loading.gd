extends Node2D

var phase:int = 0

func _ready() -> void:
	$logos.modulate.a = 0.0
	
func tween_alpha(o:float, t:float):
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($logos, "modulate", Color(1,1,1, o), t)

func _on_pass_timeout() -> void:
	phase += 1
	if phase == 1:
		$sound.play()
		$pass.wait_time = 3.0
		tween_alpha(1.0, 0.2)
		$pass.start()
	elif phase == 2:
		tween_alpha(0.0, 0.2)
		$pass.wait_time = 1.5
		$pass.start()
	elif phase == 3:
		SceneManager.change_scene("res://src/main_menu.tscn", { "speed": 7})
