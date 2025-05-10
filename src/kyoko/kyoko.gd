extends CharacterBody2D

# Variables principales
var lifes:int = 4
var status:String = "normal"
var can_shoot:bool = true
var can_move:bool = true
var triple_shoot:bool = false

# Velocidad
const SPEED:float = 460.0

# Precargar elementos
var shoot = preload("res://src/kyoko/bubble_shoot.tscn")
var heart_shoot = preload("res://src/kyoko/heart_shoot.tscn")
var charging_power = preload("res://src/kyoko/charging_power.tscn")
var special = preload("res://src/kyoko/bubble_special_shoot.tscn")

# Obtener el tamaño de la pantalla
@onready var screen_size = get_viewport_rect().size

func _ready() -> void:
	$s.play("idle")

func _input(event: InputEvent) -> void:
	# Mientras el estado no sea 'death' y las variables can_move y can_shoot sean verdaderos
	# Ella podra disparar 
	if status != "death":
		if can_move and can_shoot:
			if event.is_action_pressed("ui_accept"):
				shoot_control()
			if get_tree().get_nodes_in_group("special_bar")[0].value == 100:
				if event.is_action_pressed("special_shoot"):
					special_shoot_recharge()

func _physics_process(_delta: float) -> void:
	# Si Kyoko no esta derrotada se podra seguir moviendo
	if status != "death":
		position_control()
	else:
		death()

# Obtener que botón se esta presionando
func get_axis():
	var axis = Vector2.ZERO
	if can_move:
		axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
		axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))

	return axis

# Controlador de posición
func position_control():
	# Si el valor de retorno no es (0,0) ella se moverá
	if get_axis() == Vector2.ZERO: 
		velocity = Vector2.ZERO
	else:
		velocity = get_axis().normalized() * SPEED
	# Limita la posición de Kyoko para que no pueda salirse de la pantalla
	position.x = clamp(position.x, 35, screen_size.x - 50)
	position.y = clamp(position.y, 100, screen_size.y - 70)
	
	move_and_slide()

# Dispara los corazón, si esta activado el triple_shoot se disparan 3 corazones
func shoot_control():
	$s.animation = "shoot"
	var heart_shoot_1 =  heart_shoot.instantiate()
	heart_shoot_1.global_position = $shoot.global_position
	get_tree().call_group("game", "add_child",heart_shoot_1)
	if not triple_shoot:
		var shoot_1 = shoot.instantiate()
		shoot_1.SPEED_Y = 0
		shoot_1.global_position = $shoot.global_position
		get_tree().call_group("game", "add_child", shoot_1)
	else:
		var speed_y:float = -400.0
		for i in range(3):
			var shoot_1 = shoot.instantiate()
			shoot_1.global_position = $shoot.global_position
			shoot_1.SPEED_Y = speed_y
			get_tree().call_group("game", "add_child", shoot_1)
			speed_y += 400.0

# Recarga el poder especial, en realidad los primeros segundos son más decorativos
func special_shoot_recharge():
	var tween = create_tween()
	tween.set_parallel(true)
	var get_cam:Camera2D = get_tree().get_nodes_in_group("cam")[0]
	tween.tween_property(get_cam, "zoom", Vector2(1.1, 1.1), 0.5)
	tween.tween_property(get_cam, "offset", Vector2(56, 49), 0.5)

	Engine.time_scale = 0.3
	$special_recharge.play()
	can_move = false
	can_shoot = false
	status = "special_recharge"
	$s.animation = "special"
	var charging =  charging_power.instantiate()
	charging.global_position = $shoot.global_position
	get_tree().call_group("game", "add_child",charging)
	$SpecialShoot.start()

# Dispara el corazón gigante / acciona el poder especial 
func special_shoot():
	var tween = create_tween()
	tween.set_parallel(true)
	var get_cam:Camera2D = get_tree().get_nodes_in_group("cam")[0]
	tween.tween_property(get_cam, "zoom", Vector2(1, 1), 0.4)
	tween.tween_property(get_cam, "offset", Vector2(0, 0), 0.4)
	
	Engine.time_scale = 1
	$special_shoot_sound.play()
	get_tree().get_nodes_in_group("charging_power")[0].queue_free()
	var heart_shoot_1 =  heart_shoot.instantiate()
	heart_shoot_1.get_node("s").scale = Vector2(2,2)
	heart_shoot_1.global_position = $shoot.global_position
	get_tree().call_group("game", "add_child",heart_shoot_1)
	if not triple_shoot:
		var shoot_1 = special.instantiate()
		shoot_1.SPEED_Y = 0
		shoot_1.global_position = $shoot.global_position
		get_tree().call_group("game", "add_child", shoot_1)
	else:
		var speed_y:float = -400.0
		for i in range(3):
			var shoot_1 = special.instantiate()
			shoot_1.global_position = $shoot.global_position
			shoot_1.SPEED_Y = speed_y
			get_tree().call_group("game", "add_child", shoot_1)
			speed_y += 400.0

# Podrás volver a disparar después de esto
func _on_shoot_freeze_timeout() -> void:
	can_shoot = true
	$s.animation = "idle"

# Obtener el daño
func take_damage():
	lifes -= 1
	$damageSound.play()
	get_tree().get_nodes_in_group("life_bar")[0].value -= 1
	if lifes > 0:
		can_move = false
		status = "damage"
		$s.animation = "damage"
		$DamageFreeze.start()
	elif lifes < 1:
		$Death.start()
		$damageanim.play("damage")
		can_move = false
		status = "death"
		$s.animation = "damage"

# Después de 5 segundos, Kyoko volverá a seguir recibiendo daño
func _on_damage_freeze_timeout() -> void:
	can_move = true
	status = "damage_cooldown"
	$DamageCooldown.start()
	$damageanim.play("damage")
	$s.animation = "idle"

# Su estado será de nuevo 'normal' y ya no parpadeara
func _on_damage_cooldown_timeout() -> void:
	status = "normal"
	$damageanim.play("RESET")

# Usada para dar la animación de caerse cuando pierdes todas las vidas
func death():
	$s.animation = "damage"
	position.x -= 1
	position.y += 5

# Recupera las vidas por completo
func full_lifes():
	lifes = 4
	get_tree().get_nodes_in_group("life_bar")[0].value = 4

# Agrega una nueva vida
func lifes_plus():
	lifes += 1
	get_tree().get_nodes_in_group("life_bar")[0].value += 1

# La barra del poder especial estara al 100%
func special_power_full():
	get_tree().get_nodes_in_group("special_bar")[0].value = 100

# Ahora dispara 3 corazones al mismo tiempo pero por tiempo limitado
func triple_shoot_func():
	triple_shoot = true
	$disableTripleShoot.start()

# Después de unos segundos, aparecerá la pantalla de game_over
func _on_death_timeout() -> void:
	SceneManager.change_scene("res://src/game_over.tscn", { "speed": 3, "pattern": "squares"})

# Desactiva el disparo triple
func _on_disable_triple_shoot_timeout() -> void:
	triple_shoot = false

# Después del tiempo de recarga, se dispara el corazón gigante y volverás al estado normal
func _on_special_shoot_timeout() -> void:
	status = "normal"
	can_shoot = true
	can_move = true
	$s.animation = "idle"
	special_shoot()
	get_tree().get_nodes_in_group("special_bar")[0].value = 0
