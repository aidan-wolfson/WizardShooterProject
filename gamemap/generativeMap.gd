extends TileMap

var mapType : String = "Interior"
var types : Array = ["Interior", "Exterior"]
var allLayers : Dictionary
var placed_objects : Array
var bounds : Array
var min_distance: float = 10.0
var maxObjects : int = 10

func _ready():
	var map_Vector2_Array = (get_tree().get_root().get_node("PlayerTesting/Game_Space")).find_child("MapArea", true, true).get_polygon()
	
	#Translates the local scale and position of Gamemap corner vectors to global scale and position
	for vector in map_Vector2_Array:
		if vector.x > 0 && vector.y < 0: # filter for top right corner
			var result = vector
			bounds.append(result) 
			bounds.append(result * -1) # add bottom left corner

	print("Bounds: " + str(bounds))

func newMap():
	var newMapSel = mapType
	while newMapSel == mapType:
		newMapSel = types[randi() % types.size()]
	mapType = newMapSel 
	generateMap(mapType)
	
	

func getMapType():
	return mapType

func getAllMapTypes():
	return types

func generateMap(type):
	print("Generating map type: " + type)
	for object in placed_objects:
		object.queue_free()
	placed_objects.clear()
	for x in range(0, self.get_layers_count()):
		self.set_layer_enabled(x, false)
	if type == "Interior":
		self.set_layer_enabled(0, true)
		self.set_layer_enabled(2, true)
	elif type == "Exterior":
		self.set_layer_enabled(1, true)
		self.set_layer_enabled(3, true)
	
	for x in randi_range(0, maxObjects):
		generateObjects(type)

func generateObjects(type):
	
	var object_scene = load("res://gamemap/Map Objects/Chest.tscn")
	if type == "Interior":
		# implement walls
		pass 
	var random_position = Vector2(randf_range(bounds[1].x, bounds[0].x), randf_range(bounds[0].y, bounds[1].y))
	print("Attempting to generate obj...")
	var attempts = 0
	while is_too_close(random_position) and attempts < 10:
		print("Failed to generate obj")
		random_position = Vector2(
		randf_range(bounds[1].x, bounds[0].x),
		randf_range(bounds[0].y, bounds[1].y)
		)
		attempts += 1

	if attempts < 10:
		print("Succeeded to generate obj at postion: " + str(random_position))
		var instance = object_scene.instantiate()
		instance.global_position = random_position
		add_child(instance)
		placed_objects.append(instance)
	
func is_too_close(pos):
	for obj in placed_objects:
		if pos.distance_to(obj.global_position) < min_distance:
			return true
	return false
