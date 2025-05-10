extends enemy_base

signal death

@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("player")[0]
var explosion = preload("res://src/enemys/explosion_1.tscn")

const SPEED:float = 260.0

func _ready() -> void:
	lifes = 3
	$s.play()

func _physics_process(delta: float) -> void:
	position.x -= SPEED * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if position.x < -300:
		queue_free()

func _on_body_entered(body:Node2D) -> void:
	if player.status == "normal":
		if body.is_in_group("player"):
			player.take_damage()

func _on_death() -> void:
	var explosion_1 = explosion.instantiate()
	explosion_1.global_position = $explosion.global_position
	get_tree().call_group("game", "add_child", explosion_1)
	queue_free()

func _on_area_entered(area:Area2D) -> void:
	if area.is_in_group("shoot"):
		take_damage($damageanim, death)
	elif area.is_in_group("special_shoot"):
		take_damage($damageanim, death, 6)

func _on_damageanim_animation_finished(anim_name:StringName) -> void:
	if anim_name == "damage": $damageanim.play("RESET")
