extends Node

var fps = preload("res://src/fps.tscn")
var highscore:int = 0

var game_settings:Dictionary = {
	"fps": true,
	"fullscreen": false,
	"musicVolume": 0.8,
	"soundVolume": 0.9,
	"language": "es",
	"language_is_change": false,
	"ctc": 0.1,
}
var game_data:Dictionary = {
	"score": 0,
	"chapter": 0,
	"firstStart": false
}

func random_randint(minim:int, maxim:int):
	var random = RandomNumberGenerator.new()
	random.randomize()
	
	return	random.randi_range(minim, maxim)

#### Guardar y cargar la data del juego #####
# Nombre de los archivos de data del juego
var save_data = "user://data001.dat"
var save_config = "user://data002.dat"

# Guardar los datos
func Save(t:String) -> void:
	var f = ""
	if t == "data": f = save_data
	if t == "config": f = save_config
		
	var save_file = FileAccess.open(f, FileAccess.WRITE) # Crea el archivo de guardado
	if t == "data":
		save_file.store_var(GLOBAL.game_data) # Almacena la variable en el archivo
	elif t == "config":
		save_file.store_var(GLOBAL.game_settings) # Almacena la variable en el archivo
	save_file = null # cierra el archivo
		
	print("El archivo " + f + " a sido guardado.")

# Cargar los datos
func Load(t:String) -> void:
	var f = ""
	if t == "data": f = save_data
	if t == "config": f = save_config
	# El archivo de guardado existe?
	if FileAccess.file_exists(f):
		var save_file = FileAccess.open(f, FileAccess.READ) # Obtiene el archivo
		if t == "data":
			game_data = save_file.get_var()
		elif t == "config":
			game_settings = save_file.get_var()
		save_file = null # Cierra el archivo
		print("El archivo " + f + " a sido cargado existosamente")
	else:
		print("No existe el archivo " + f)
	
func DeleteData(t:String) -> void:
	var f = ""
	if t == "data": f = save_data
	if t == "config": f = save_config
	# El archivo de guardado existe?
	if FileAccess.file_exists(f):
		DirAccess.remove_absolute(f)

# Guardar o cargar la data o configuración del juego
func SaveGameData():
	Save("data")
func LoadGameData():
	Load("data")
func SaveGameSettings():
	Save("config")
func LoadGameSettings():
	Load("config")
func DeleteGameData():
	DeleteData("data")
func DeleteGameSettings():
	DeleteData("config")

# Cada escena cargara este ready para cargar datos o para configurar la ventana
func _ready() -> void:
	# Cargar los datos
	LoadGameData()
	LoadGameSettings()
	
	# Cambiar a pantalla completa si...
	if game_settings["fullscreen"]:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN) 
	
	# Agrega la capa del contador FPS
	var fps_1 = fps.instantiate()
	add_child(fps_1)
		
	# Cambia el color del fondo general del juego
	RenderingServer.set_default_clear_color(Color.BLACK) 
	
	# Asignar el volumen
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music"), linear_to_db(game_settings["musicVolume"]))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("sounds"), linear_to_db(game_settings["soundVolume"]))
	
	# Cambiar el idioma
	if game_settings["language"]:	
		TranslationServer.set_locale(game_settings["language"])
