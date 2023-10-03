extends Area2D

#Called when object enters area
func _on_body_entered(body):
	#This line finds the player object in the current scene
	var player = (get_tree().get_root().get_node("PlayerTesting")).find_child("Player", true, true)
	
	#This block moves the player to the location of the other teleporter, offset a little
	#The if/elif figures out which scene the teleporter node is in
	if self.find_parent("Tower_Space"):
		#This line instantiates targetNode as the teleporter in the other scene, either Tower Space 
		#or Game Space
		var targetNode = ((get_tree().get_root().get_node("PlayerTesting/Game_Space")).find_child("Teleporter", true, true))
		
		#These lines find the proper location by taking into account both the teleporter's location 
		#within the PlayerTesting scene (as seen with targetNode.global_position) and their local 
		#position within their scene. It also adds an offset, so that the player isn't teleported 
		#into the other teleporter, thus triggering another teleport.
		player.position = targetNode.global_position + targetNode.get_child(0).position + Vector2(0,30)
		player.velocity = Vector2.ZERO
		
	elif self.find_parent("Game_Space"):
		var targetNode = ((get_tree().get_root().get_node("PlayerTesting/Tower_Space")).find_child("Teleporter", true, true))
		player.position = targetNode.global_position + targetNode.get_child(0).position + Vector2(0,30)
		player.velocity = Vector2.ZERO

