extends Area2D
class_name enemy_base

var lifes:int = 4

func take_damage(d:AnimationPlayer, s:Signal, l:int = 1):
	lifes -= l
	if lifes > 0: 
		d.play("damage")
	elif lifes <= 0:
		GLOBAL.highscore += 1
		s.emit()
