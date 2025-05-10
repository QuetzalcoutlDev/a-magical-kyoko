extends Area2D

@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("player")[0]
const SPEED:float = 260.0
var id:int
@onready var explosion = preload("res://src/kyoko/power_up_explosion.tscn")

func _ready() -> void:
	id = GLOBAL.random_randint(1, 4)
	$s.animation = str(id)
	
func _physics_process(delta: float) -> void:
	position.x -= SPEED * delta

func _on_body_entered(body: Node2D) -> void:
	if player.status != "death":
		if body.is_in_group("player"):
			var explosion_1 = explosion.instantiate()
			explosion_1.global_position = $explosion.global_position
			get_tree().call_group("game", "add_child", explosion_1)
			
			if id == 1: player.lifes_plus()
			elif id == 2: player.triple_shoot_func()
			elif id == 3: player.full_lifes()
			elif id == 4: player.special_power_full()
			#elif id == 5: player.special_power_full()
			
			queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if position.x < -300:
		queue_free()
