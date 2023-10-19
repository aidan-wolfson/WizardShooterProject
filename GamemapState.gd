extends GameState
class_name GamemapState

func Enter():
	#tell wave object to start next wave
	pass


func Update(delta):
	#Grabs array of vectors of each "MapArea" Node for the specified scene
	var mapAreaNode = (get_tree().get_root().get_node("PlayerTesting/Game_Space")).find_child("CollisionPolygon2D", true, true)
	var map_Vector2_Array = mapAreaNode.get_polygon()
	
	#Translates the local scale and position of vectors to global scale and position
	for vector in map_Vector2_Array:
		var result = Vector2(vector[0], vector[1]) * Vector2(mapAreaNode.global_scale)
		result = result + Vector2(mapAreaNode.global_position)
		map_Vector2_Array.set(map_Vector2_Array.find(vector), result)
	
	var player = get_tree().get_root().get_node("PlayerTesting").find_child("Player", true, true)
	if player and !(is_player_outside_map(player.global_position, map_Vector2_Array)): # Function defined in "GameState" class
		Transition.emit(self, "towerstate") #Signal to GameStateMachine to swap to "gamemapstate"
