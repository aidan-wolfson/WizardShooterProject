extends GameState
class_name TowerState

func Enter():
	get_tree().get_root().get_node("PlayerTesting/Game_Space").find_child("TileMap", true, true).newMap()

func Update(delta):
	#Grabs array of vectors of each "MapArea" Node for the specified scene
	var map_Vector2_Array = (get_tree().get_root().get_node("PlayerTesting/Tower_Space")).find_child("MapArea", true, true).get_polygon()
	
	#Translates the local scale and position of vectors to global scale and position
	for vector in map_Vector2_Array:
		var result = Vector2(vector[0], vector[1]) * Vector2(((get_tree().get_root().get_node("PlayerTesting")).find_child("Tower_Space", true, true)).global_scale)
		result = result + Vector2((get_tree().get_root().get_node("PlayerTesting/Tower_Space")).find_child("MapArea", true, true).global_position)
		map_Vector2_Array.set(map_Vector2_Array.find(vector), result)
	
	var player = get_tree().get_root().get_node("PlayerTesting").find_child("Player", true, true)
	if !(is_player_outside_map(player.global_position, map_Vector2_Array)): # Function defined in "GameState" class
		#print("Player is outside!!!")
		Transition.emit(self, "gamemapstate") #Signal to GameStateMachine to swap to "gamemapstate"


