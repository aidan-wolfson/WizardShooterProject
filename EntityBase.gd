extends CharacterBody2D

const SPEED = 300.0

@export var hp_max: int = 100
@export var hp: int = hp_max
@export var defense: int = 0

@onready var sprite = $Sprite2D
@onready var collShape = $CollisionShape2D
@onready var animPlayer = $AnimationPlayer

func die():
	queue_free()

