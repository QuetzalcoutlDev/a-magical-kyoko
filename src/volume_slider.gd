extends HSlider

@export var bus_name: String = "Master"
@onready var bus_index: int = AudioServer.get_bus_index(bus_name)

func _ready() -> void:
	value = db_to_linear(
		AudioServer.get_bus_volume_db(bus_index)
	)

func _on_value_changed(value: float) -> void:
	print("Valor del slider " + bus_name + " " + str(value), " Valor de bus_index"  + bus_name + " " + str(bus_index))
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(value)
	)
	
	if bus_name == "music": GLOBAL.game_settings["musicVolume"] = value
	if bus_name == "sounds": GLOBAL.game_settings["soundVolume"] = value
