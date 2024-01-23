extends "res://enemy.gd"

func _on_enemy_hitbox_area_entered(area):
	if area.is_in_group("Projectile"):
		# getting hit by projectile
		var damage = area.damage # damage being dealt to enemy
		receiveKnockback(area.global_position, damage) 
		receiveDamage(damage)
		print_debug("enemy hit for " + str(damage) + " damage!")
