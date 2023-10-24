extends CharacterBody2D

@export var MAX_HP = 50
@export var CURRENT_HP = 50

@export var MAX_SPEED = 300
@export var ACCELERATION = 15000
@export var FRICTION = 1200
@export var is_alive : bool = true

@export var PROJECTILE: PackedScene = preload("res://projectiles/projectile.tscn")
@export var in_enemy_range : bool

@onready var axis = Vector2.ZERO
@onready var attackTimer = $AttackTimer
@onready var enemyAttackTimer = $EnemyAttackTimer
@onready var _animation_player = $AnimationPlayer
@onready var spriteNode = $Sprite2D

signal player_died

func _physics_process(delta):
	if is_alive:
		move(delta)
		animationHandler()
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

func receiveDamage(dmg: int):
	CURRENT_HP -= dmg
	if CURRENT_HP <= 0:
		die()
	
	# damage flash effect
	spriteNode.modulate = Color.DARK_RED
	await get_tree().create_timer(0.15).timeout
	spriteNode.modulate = Color.WHITE
	
	print_debug("Wuh oh! We've been hit for " + str(dmg) + " damage! " + str(CURRENT_HP) + " hp remaining")

func fire_projectile(projectile_direction: Vector2):
	if PROJECTILE:
		var projectile = PROJECTILE.instantiate()
		get_parent().add_child(projectile)
		projectile.global_position = self.global_position #instantiate the projectile at the player's pos
		
		var projectile_rotation = projectile_direction.angle()
		projectile.rotation = projectile_rotation #set projectile rot to point at mouse pos
		
		attackTimer.start()
		
func animationHandler():
	if self.axis == Vector2.ZERO:
		_animation_player.play("RestDown")
		get_node( "Sprite2D" ).set_flip_h( false )
	else:
		var directionRadians = ((self.axis).angle())
		# Normalize radian to [0, 2π]
		while directionRadians < 0:
			directionRadians += 2 * PI
		directionRadians = fmod(directionRadians, 2 * PI)

		# Convert radian to direction
		if 0 <= directionRadians and directionRadians < PI / 4:
			_animation_player.play("WalkRight")
			get_node( "Sprite2D" ).set_flip_h( false )
		elif PI / 4 <= directionRadians and directionRadians < 3 * PI / 4:
			_animation_player.play("WalkDown")
			get_node( "Sprite2D" ).set_flip_h( false )
		elif 3 * PI / 4 <= directionRadians and directionRadians < 5 * PI / 4:
			_animation_player.play("WalkRight")
			get_node( "Sprite2D" ).set_flip_h( true )
		else:
			_animation_player.play("WalkUp")
			get_node( "Sprite2D" ).set_flip_h( false )
	_animation_player.advance(0)

func die():
	is_alive = false
	#play death animation
	_animation_player.play("Die")
	await _animation_player.animation_finished
	#wait 3 seconds
	print_debug("Player died! Waiting 3 seconds...")
	await get_tree().create_timer(3.0).timeout
	#emit death signal
	emit_signal("player_died")
	#queue_free()

func _on_player_hitbox_area_entered(area):
	print_debug("Area entered")
	in_enemy_range = true
	print_debug("Are we in enemy range? -> " + str(in_enemy_range))

func _on_player_hitbox_area_exited(area):
	print_debug("Area exited")
	in_enemy_range = false
	print_debug("Are we in enemy range? -> " + str(in_enemy_range))
