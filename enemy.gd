extends CharacterBody2D

@export var MAX_HP = 50
@export var CURRENT_HP = 50
@export var move_speed : float = 30
@export var move_dir : Vector2
@export var damage : int
@export var in_attack_range : bool
@export var is_alive : bool

@export var receives_knockback: bool = true
@export var knockback_modifier: float = 0.1

@onready var _animation_player = $AnimationPlayer
@onready var spriteNode = $Sprite2D
@onready var enemyAttackTimer = $AttackTimer
@onready var damageNumber = $DamagePopLocation
@onready var hitbox = $enemy_hitbox
#@onready var hitbox = $Area2D
@onready var player = (get_tree().get_root().get_node("PlayerTesting")).find_child("Player", true, true)
# animationPlayer.play("idle")
# animationPlayer.play("walk")

var start_pos : Vector2
var target_pos : Vector2
var motion : Vector2

func _ready():
	randomize()
	start_pos = global_position
	target_pos = start_pos + move_dir
	in_attack_range = false
	is_alive = true

func _physics_process(delta):
	if is_alive:
		move()
		animationHandler()
		attack()

func move():
	velocity = Vector2.ZERO
	if player != null and player.is_alive == true:
		velocity += (global_position.direction_to(player.position) * move_speed)
	elif player.is_alive == false:
		velocity = Vector2.ZERO
	# look_at(player.position)
	move_and_slide()

func animationHandler():
	if velocity.x < 0:
		# enemy is moving left
		_animation_player.play("walk")
		spriteNode.set_flip_h( false )
	elif velocity.x > 0:
		# enemy is moving right, don't flip
		_animation_player.play("walk")
		spriteNode.set_flip_h( true )
	elif velocity == Vector2.ZERO:
		_animation_player.play("idle")

func attack():
	if player.is_alive:
		if in_attack_range and enemyAttackTimer.is_stopped():
			player.receiveDamage(damage)
			enemyAttackTimer.start()

func die():
	player.changeVariable("Money", 1)
	is_alive = false
	hitbox.collision_layer = 0
	hitbox.collision_mask = 0
	$Sprite2D.modulate.a = 0.5
	_animation_player.play("death")
	
	await _animation_player.animation_finished
	await get_tree().create_timer(1.0).timeout
	queue_free()

func receiveDamage(dmg: int):
	CURRENT_HP -= dmg
	if CURRENT_HP <= 0:
		die()
	
	# damage number popup
	damageNumber.popup(dmg)
	
	# damage flash effect
	spriteNode.modulate = Color.DARK_RED
	await get_tree().create_timer(0.15).timeout
	spriteNode.modulate = Color.WHITE

func receiveKnockback(damage_source_pos: Vector2, received_damage: int):
	if receives_knockback:
		#calculate knockback direction
		var knockback_direction = damage_source_pos.direction_to(self.global_position)
		# need to find a better way to calculate strength here
		var knockback_strength = received_damage * knockback_modifier
		var knockback = knockback_direction * knockback_strength
		
		global_position += knockback

func _on_hitbox_area_entered(area):
	#if area.is_in_group("Player"):
	#	# attack the player
	#	print_debug("Player entered enemy hitbox area")
	#	in_attack_range = true
	if area.is_in_group("Projectile"):
		# getting hit by projectile
		var damage = area.damage # damage being dealt to enemy
		receiveKnockback(area.global_position, damage) 
		receiveDamage(damage)
		#print_debug("enemy hit for " + str(damage) + " damage!")

func _on_enemy_hitbox_area_exited(area):
	pass
	#if area.is_in_group("Player"):
	#	print_debug("Player out of range")
	#	in_attack_range = false

func _on_enemy_attack_range_area_entered(area):
	if area.is_in_group("Player"):
		# attack the player
		#print_debug("Player entered enemy hitbox area")
		in_attack_range = true

func _on_enemy_attack_range_area_exited(area):
	if area.is_in_group("Player"):
		#print_debug("Player out of range")
		in_attack_range = false
