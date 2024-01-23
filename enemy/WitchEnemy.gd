extends "res://enemy.gd"

@export var PROJECTILE: PackedScene = preload("res://projectiles/witch_projectile.tscn")

@onready var rangedAttackSound = $attackSound

func attack():
	if player.is_alive:
		if in_attack_range and enemyAttackTimer.is_stopped():
			var projectile_dir = self.global_position.direction_to(player.global_position)
			fire_projectile(projectile_dir)
			#player.receiveDamage(damage)
			enemyAttackTimer.start()

func fire_projectile(projectile_direction: Vector2):
	if PROJECTILE:
		var projectile = PROJECTILE.instantiate()
		get_parent().add_child(projectile)
		projectile.global_position = self.global_position #instantiate the projectile at the player's pos
		
		var projectile_rotation = projectile_direction.angle()
		projectile.rotation = projectile_rotation #set projectile rot to point at mouse pos
		
		rangedAttackSound.play()
		enemyAttackTimer.start()

func _on_enemy_attack_range_area_entered(area):
	if area.is_in_group("Player"):
		in_attack_range = true

func _on_enemy_attack_range_area_exited(area):
	if area.is_in_group("Player"):
		in_attack_range = false

func _on_enemy_hitbox_area_entered(area):
	if area.is_in_group("Projectile"):
		# getting hit by projectile
		var damage = area.damage # damage being dealt to enemy
		receiveKnockback(area.global_position, damage) 
		receiveDamage(damage)
		print_debug("enemy hit for " + str(damage) + " damage!")
