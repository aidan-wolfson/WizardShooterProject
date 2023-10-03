extends CharacterBody2D

@export var MAX_HP = 50
@export var CURRENT_HP = 50

@export var MAX_SPEED = 300
@export var ACCELERATION = 15000
@export var FRICTION = 1200

@export var PROJECTILE: PackedScene = preload("res://projectiles/projectile.tscn")

@onready var axis = Vector2.ZERO
@onready var attackTimer = $AttackTimer

func _physics_process(delta):
	move(delta)
	
	if Input.is_action_just_pressed("action_attack") and attackTimer.is_stopped():
		var projectile_dir = self.global_position.direction_to(get_global_mouse_position())
		fire_projectile(projectile_dir)

func get_input_axis():
	axis.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	axis.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	return axis.normalized()

func move(delta):
	axis = get_input_axis()
	if axis == Vector2.ZERO:
		apply_friction(FRICTION * delta)
	else:
		apply_movement(axis * ACCELERATION * delta)

	move_and_slide()

func apply_friction(amount):
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO

func apply_movement(accel):
	velocity += accel
	velocity = velocity.limit_length(MAX_SPEED)

func fire_projectile(projectile_direction: Vector2):
	if PROJECTILE:
		var projectile = PROJECTILE.instantiate()
		get_parent().add_child(projectile)
		projectile.global_position = self.global_position #instantiate the projectile at the player's pos
		
		var projectile_rotation = projectile_direction.angle()
		projectile.rotation = projectile_rotation #set projectile rot to point at mouse pos
		
		attackTimer.start()

func die():
	queue_free()


