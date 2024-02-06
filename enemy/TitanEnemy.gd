extends "res://enemy.gd"

@onready var walkSFX = $walkSound
@onready var damageSFX = $damageSound
@onready var deathSFX = $deathSound


func _on_enemy_hitbox_area_entered(area):
	if area.is_in_group("Projectile"):
		# getting hit by projectile
		var damage = area.damage # damage being dealt to enemy
		receiveKnockback(area.global_position, damage) 
		receiveDamage(damage)
		damageSFX.pitch_scale = randf_range(0.9,1.2)
		damageSFX.play()
		print_debug("enemy hit for " + str(damage) + " damage!")

func animationHandler():
	pass
	##Overrides enemy base function, used to prevent flipping the sprite

func playWalkSFX():
	walkSFX.play()

func _on_enemy_attack_range_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area.is_in_group("Player"):
		# attack the player
		#print_debug("Player entered enemy hitbox area")
		in_attack_range = true

func _on_enemy_attack_range_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if area.is_in_group("Player"):
		in_attack_range = false

