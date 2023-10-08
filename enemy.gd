extends CharacterBody2D

@export var MAX_HP = 50
@export var CURRENT_HP = 50

func die():
	queue_free()

func receiveDamage(dmg: int):
	CURRENT_HP -= dmg
	if CURRENT_HP <= 0:
		die()



