extends Node2D

#
var phase = 0
@onready var enemySpawnTime = $EnemySpawn.wait_time

# Kyoko y los power ups
var kyoko = preload("res://src/kyoko/kyoko.tscn")
var powers = preload("res://src/kyoko/power_ups.tscn")

# enemys
var enemy_list = [
	"slime",
	"eye",
	"robot"
]
var slime = preload("res://src/enemys/slime.tscn")
var eye  = preload("res://src/enemys/eye.tscn")
var robot = preload("res://src/enemys/robot.tscn")

# backgrounds
var city = preload("res://src/backgrounds/city.tscn")

# otras pantallas
var pause = preload("res://src/pause.tscn")

func _ready() -> void:
	GLOBAL.highscore = 0
	
	# Conectar la señal de pausa con la función pause_game
	$gui.connect("pause_game", pause_game)
	
	# Agregar el fondo
	var bg = city.instantiate()
	add_child(bg)
	
	# Agrega a Kyoko y posicionala en el marcador Start
	var kyoko_1 = kyoko.instantiate()
	add_child(kyoko_1)
	kyoko_1.position = $Start.global_position
	
	# Cambia el valor de vidas
	$gui/stats/lifesBar.value = kyoko_1.lifes
	
	#AudioPlayer.stop()
	AudioPlayer.play_game_theme()
	#$theme.play()
	if not GLOBAL.game_data["firstStart"]:
		get_tree().get_nodes_in_group("player")[0].can_move = false
		Dialogic.timeline_ended.connect(ended_dialog)
		Dialogic.start("res://src/dialogs/start.dtl")
	else:
		start_timers()

# No hay muchas teclas presionadas además de la de pausa
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and get_tree().get_nodes_in_group("player")[0].can_move:
		pause_game()
		
# Agrega un nuevo enemigo en la escena
func _on_enemy_spawn_timeout() -> void:
	var enemy_name = enemy_list[GLOBAL.random_randint(0,phase)]
	var enemy:Area2D = get(enemy_name).instantiate()
	add_child(enemy)
	enemy.global_position = Vector2(1400, GLOBAL.random_randint(80, 640))

# Agrega un nuevo powerup en la escena
func _on_powers_spawn_timeout() -> void:
	var powers_1:Area2D = powers.instantiate()
	add_child(powers_1)
	powers_1.global_position = Vector2(1400, GLOBAL.random_randint(80, 640))

# Mientras la barra de especial, no este al 100% se ira recargando de a poco
func _on_recharge_special_timeout() -> void:
	if $gui/stats/specialBar.value != 100:
		$gui/stats/specialBar.value += 1

# Agrega la escena de pausa y pausa el arbol de escena completo
func pause_game():
	var pause_1 = pause.instantiate()
	add_child(pause_1)
	get_tree().paused = true

# Iniciar los temporizadores necesarios
func start_timers():
	$EnemySpawn.start()
	$PowersSpawn.start()
	$rechargeSpecial.start()
	$changePhase.start()
	$changeEnemySpawnTime.start()

func ended_dialog():
	GLOBAL.game_data["firstStart"] = true
	get_tree().get_nodes_in_group("player")[0].can_move = true
	start_timers()
	GLOBAL.SaveGameData()

func _on_change_phase_timeout() -> void:
	if phase != 2:
		phase += 1

func _on_change_enemy_spawn_time_timeout() -> void:
	if enemySpawnTime != 1:
		enemySpawnTime -= 1
		$EnemySpawn.wait_time = enemySpawnTime
		$EnemySpawn.start()
