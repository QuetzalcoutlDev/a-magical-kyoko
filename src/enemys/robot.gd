extends enemy_base

signal death

@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("player")[0]
var explosion = preload("res://src/enemys/explosion_1.tscn")

var speed:float = 260.0
var speed_y:float = 260.0

var limit = false
var lock = false

# Obtener el tamaño de la pantalla
@onready var screen_size = get_viewport_rect().size

func _ready() -> void:
	lifes = 24
	if GLOBAL.random_randint(0, 1) == 1: speed_y *= -1

func _physics_process(delta: float) -> void:
	position.x -= speed * delta
	position.y -= speed_y * delta
	
	# Limitar la posición del robot
	if limit:
		position.x = clamp(position.x, 45, screen_size.x - 50)
		position.y = clamp(position.y, 50, screen_size.y - 70)

func _process(delta: float) -> void:
	$s.rotation -= 3 * delta
	
	# Cambia la dirección del robot al colisionar con los bordes de la pantalla
	if not lock and limit:
		if position.x < 46 or position.x > 1229: 
			speed *= -1
			$lockFalse.start()
			lock = true
		if position.y < 51 or position.y > 639: 
			speed_y *= -1
			$lockFalse.start()
			lock = true
	
func _on_damageanim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "damage": $damageanim.play("RESET")

func _on_death() -> void:
	var explosion_1 = explosion.instantiate()
	explosion_1.global_position = $explosion.global_position
	get_tree().call_group("game", "add_child", explosion_1)
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if player.status == "normal":
		if body.is_in_group("player"):
			player.take_damage()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("shoot"):
		take_damage($damageanim, death)
	elif area.is_in_group("special_shoot"):
		take_damage($damageanim, death, 6)

# Al ser visible en la pantalla, ahora se limitara la posición
func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	limit = true

func _on_lock_false_timeout() -> void:
	lock = false
