extends Node2D

func _ready() -> void:
	$s.play()

func _on_s_animation_finished() -> void:
	queue_free()
