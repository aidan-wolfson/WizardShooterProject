extends CharacterBody2D

@export var MAX_HP = 50
@export var CURRENT_HP = 50

@export var MAX_SPEED = 300
@export var ACCELERATION = 15000
@export var FRICTION = 1200
@export var DODGE_SPEED = 900
@export var DODGE_STAMINA = 100
@export var DODGE_RECHARGEVAL = 10
@export var is_alive : bool = true
@export var dodgeZoom : Vector2 = Vector2(0.75,0.75)
@export var staff_offset : int = 26.5

@export var PROJECTILE: PackedScene = preload("res://projectiles/projectile.tscn")

@export var in_enemy_range : bool = false
@onready var projectileDamage : int = 10


@onready var axis = Vector2.ZERO
@onready var rollVector = Vector2.ZERO
@onready var attackTimer = $AttackTimer
@onready var dodgeTimer = $DodgeTimer
@onready var dodgeRechargeTimer = $DodgeRecharge
@onready var enemyAttackTimer = $EnemyAttackTimer
@onready var _animation_player = $AnimationPlayer
@onready var spriteNode = $Sprite2D
@onready var spellAudioPlayer = $SpellSFX
@onready var dodgeAudioPlayer = $DodgeSFX
@onready var hitbox = $player_hitbox
@onready var camera = $Camera2D
@onready var staff = $StaffSprite
@onready var projSpawn = $StaffSprite/ProjectileSpawn


@onready var money : int = 0

signal player_died
signal health_changed
signal stamina_changed

enum state {DODGING, SHIELDING, RUNGUN} # RUNGUN is the default state lol

var player_state = state.RUNGUN

func _physics_process(delta):
	if is_alive:
		# if we're in the RUNGUN state
		if player_state != state.DODGING:
			camera.adjustZoom(delta, Vector2(0.8,0.8))
			move(delta)
			if Input.is_action_pressed("action_attack") and attackTimer.is_stopped():
				var projectile_dir = self.global_position.direction_to(get_global_mouse_position())
				fire_projectile(projectile_dir)
			
			if velocity != Vector2.ZERO and Input.is_action_just_pressed("dodge") and DODGE_STAMINA >= 50:
				player_state = state.DODGING
				rollVector = velocity.normalized()
				dodgeTimer.start()
				
				#reduce dodge stamina
				if DODGE_STAMINA - 50 < 0:
					DODGE_STAMINA = 0
				else:
					DODGE_STAMINA -= 50
				stamina_changed.emit()
				
				#play SFX
				dodgeAudioPlayer.play()
				
				print_debug("we're dodging!!! Dodge Stamina is: " + str(DODGE_STAMINA))
		
		elif player_state == state.DODGING:
			# what do we do while dodging? well we play the dodge animation
			dodge_state(delta)
		
		animationHandler()
		dodge_recharge()

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

func dodge_state(delta):
	# set collisions
	self.collision_layer = 0
	hitbox.collision_layer = 0
	hitbox.collision_mask = 1
	
	camera.adjustZoom(delta, dodgeZoom)
	velocity = rollVector * DODGE_SPEED
	move_and_slide()
	if dodgeTimer.is_stopped():
		# reset collisions
		self.collision_layer = 2
		hitbox.collision_layer = 2
		hitbox.collision_mask = 17
		
		player_state = state.RUNGUN
		spriteNode.modulate = Color.WHITE
		

func dodge_recharge():
	if dodgeRechargeTimer.is_stopped():
		if DODGE_STAMINA + DODGE_RECHARGEVAL >= 100:
			DODGE_STAMINA = 100
		else: 
			DODGE_STAMINA += DODGE_RECHARGEVAL
		dodgeRechargeTimer.start()
		stamina_changed.emit()

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
	health_changed.emit()
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
		projectile.global_position = projSpawn.global_position #instantiate the projectile at the player's pos
		
		var projectile_rotation = projectile_direction.angle()
		projectile.rotation = projectile_rotation #set projectile rot to point at mouse pos
		
		spellAudioPlayer.play()
		attackTimer.start()
		
		
func animationHandler():
	var is_facing_left : bool
	if player_state == state.RUNGUN:
		if self.axis == Vector2.ZERO:
			_animation_player.play("Idle")
			#get_node( "Sprite2D" ).set_flip_h( false )
		else:
			#var directionRadians = ((self.axis).angle())
			if velocity.x <= 0:
				_animation_player.play("Walk")  # Assuming you have a "WalkLeft" animation
				spriteNode.set_flip_h(true)  # Flip sprite for left direction
				is_facing_left = true
			else:
				_animation_player.play("Walk")  # Use "WalkRight" for right and the default case
				spriteNode.set_flip_h(false)  # Normal orientation for right direction
				is_facing_left = false
				_animation_player.advance(0)
		
		
		# rotate staff sprite to mouse position
		var staff_dir = self.global_position.direction_to(get_global_mouse_position())
		var staff_rotation = staff_dir.angle()
		staff.z_index = 0
		#print_debug(str(staff_rotation))
		if staff_rotation < -1.57 or staff_rotation > 1.57:
			# on player left
			staff.position = Vector2(-staff_offset,0.0)
		else:
			# on player right
			staff.position = Vector2(staff_offset,0.0)
		# set staff rotation and adjust for sprite radian difference
		staff.rotation = (staff_rotation + 0.785398)
	
	elif player_state == state.DODGING:
		#play animation
		spriteNode.modulate = Color.GRAY
		pass
	

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
	if area.is_in_group("Projectile"):
		print_debug("Ouchy, an enemy projectile hit us")
		var damage = area.damage # damage being dealt by projectile
		receiveDamage(damage)

func _on_player_hitbox_area_exited(area):
		if area.is_in_group("Enemy"):
			in_enemy_range = false

func _on_player_hitbox_body_entered(body):
	# need to improve
	if body.is_in_group("Enemy"):
		in_enemy_range = true
		enemyAttackTimer.start()
		
func changeVariable(varName, amount):
	var newAmount
	if varName == "Money":
		self.money += amount
		newAmount = self.money
	elif varName == "projectileDamage":
		self.projectileDamage += amount
		newAmount = self.projectileDamage
	elif varName == "Attack Speed":
		if $AttackTimer.wait_time > 0:
			$AttackTimer.wait_time += amount
		newAmount = $AttackTimer.wait_time
	elif varName == "Speed":
		self.MAX_SPEED += amount
		newAmount = self.MAX_SPEED
	#print("Variable " + str(name) + " changed by: " + str(amount) + ". New amount: " + str(newAmount))
	return newAmount

