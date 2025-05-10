extends Area2D

@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("player")[0]
var explosion = preload("res://src/kyoko/heart_explosion_1.tscn")

const SPEED:float = 900.0
var SPEED_Y:float = 0

func _ready() -> void:
	player.can_shoot = false
	player.get_node("ShootFreeze").start()

func _physics_process(delta: float) -> void:
	position.x += SPEED * delta
	position.y += SPEED_Y * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body:Node2D) -> void:
	if body.is_in_group("enemys"):
		var explosion_1 = explosion.instantiate()
		explosion_1.global_position = global_position
		get_tree().call_group("game", "add_child", explosion_1)
		queue_free()

func _on_area_entered(area:Area2D) -> void:
	if area.is_in_group("enemys"):
		var explosion_1 = explosion.instantiate()
		explosion_1.global_position = global_position
		get_tree().call_group("game", "add_child", explosion_1)
		queue_free()
