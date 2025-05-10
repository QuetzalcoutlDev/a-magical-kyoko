extends enemy_base

signal death

@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("player")[0]
var explosion = preload("res://src/enemys/eye_fire_explosion.tscn")

var shoot = preload("res://src/enemys/eye_fire.tscn")

var speed:float = 400.0
var speed_y:float = 300.0
var phase = 0
var up = false

# Obtener el tamaño de la pantalla
@onready var screen_size = get_viewport_rect().size

func _ready() -> void:
	if GLOBAL.random_randint(0, 1) == 1:
		up = true
	lifes = 12
	$s.play()
	$startMove.start()

func _physics_process(delta: float) -> void:
	if phase == 0 or phase == 2:
		position.x -= speed * delta
	elif phase == 1:
		move_control(delta)
	
func _on_start_move_timeout() -> void:
	$PhaseChange.start()
	$Shoot.start()
	$change_dir.start()
	phase += 1

func _on_phase_change_timeout() -> void:
	$Shoot.stop()
	speed = 600.0
	phase += 1

func move_control(delta):
	if up:
		position.y -= speed_y * delta
	else:
		position.y += speed_y * delta
	position.y = clamp(position.y, 100, screen_size.y - 70)
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if position.x < -300:
		queue_free()

func _on_shoot_timeout() -> void:
	shoot_control()

func _on_death() -> void:
	var explosion_1 = explosion.instantiate()
	explosion_1.global_position = $explosion.global_position
	get_tree().call_group("game", "add_child", explosion_1)
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("shoot"):
		take_damage($damageanim, death)
	elif area.is_in_group("special_shoot"):
		take_damage($damageanim, death, 5)

func _on_body_entered(body: Node2D) -> void:
	if player.status == "normal":
		if body.is_in_group("player"):
			player.take_damage()
			
func _on_damageanim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "damage": $damageanim.play("RESET")

func shoot_control():
	var speed_y:float = -600.0
	var explosion_1 = explosion.instantiate()
	explosion_1.global_position =  $shootPos.global_position
	get_tree().call_group("game", "add_child", explosion_1)
	for i in range(3):
		var shoot_1 = shoot.instantiate()
		shoot_1.global_position = $shootPos.global_position
		shoot_1.SPEED_Y = speed_y
		get_tree().call_group("game", "add_child", shoot_1)
		speed_y += 600.0

func _on_change_dir_timeout() -> void:
	up = not up
