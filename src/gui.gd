extends CanvasLayer

signal pause_game

func _on_lifes_bar_value_changed(value: float) -> void:
	print("Valor cambiado, ahora el valor es " + str(value))
	print("Estado actual de Kyoko es " + get_tree().get_nodes_in_group("player")[0].status)

func _on_pause_button_pressed() -> void:
	pause_game.emit()

func _process(_delta: float) -> void:
	$score.text = str(GLOBAL.highscore)
