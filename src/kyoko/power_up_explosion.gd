extends Node2D

@onready var explosion = preload("res://src/kyoko/power_up_explosion.tscn")

func _ready() -> void:
	$s.play()
	
func _on_s_animation_finished() -> void:
	queue_free()
