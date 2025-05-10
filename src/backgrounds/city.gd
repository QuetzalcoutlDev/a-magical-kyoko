extends Node2D

func _physics_process(delta: float) -> void:
	$bg/city.scroll_base_offset -= Vector2(6, 0) * 64 * delta
	$bg/city2.scroll_base_offset -= Vector2(2, 0) * 48 * delta
	$bg/city3.scroll_base_offset -= Vector2(1, 0) * 48 * delta
	$bg/clouds.scroll_base_offset -= Vector2(1, 0) * 48 * delta
