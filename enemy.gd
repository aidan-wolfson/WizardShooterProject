extends CharacterBody2D

@export var MAX_HP = 50
@export var CURRENT_HP = 50
@export var move_speed : float = 30
@export var move_dir : Vector2

@onready var _animation_player = $AnimationPlayer
@onready var spriteNode = $Sprite2D
@onready var player = (get_tree().get_root().get_node("PlayerTesting")).find_child("Player", true, true)
# animationPlayer.play("idle")
# animationPlayer.play("walk")

var start_pos : Vector2
var target_pos : Vector2
var motion : Vector2

func _ready():
	start_pos = global_position
	target_pos = start_pos + move_dir

func _physics_process(delta):
	move()
	animationHandler()

func move():
	velocity = Vector2.ZERO
	velocity += (global_position.direction_to(player.position) * move_speed)
	# look_at(player.position)
	move_and_slide()

func animationHandler():
	if velocity.x < 0:
		# enemy is moving left
		_animation_player.play("walk")
		spriteNode.set_flip_h( true )
	elif velocity.x > 0:
		# enemy is moving right
		_animation_player.play("walk")
		spriteNode.set_flip_h( false )
	elif velocity == Vector2.ZERO:
		_animation_player.play("idle")

func die():
	queue_free()

func receiveDamage(dmg: int):
	CURRENT_HP -= dmg
	if CURRENT_HP <= 0:
		die()
