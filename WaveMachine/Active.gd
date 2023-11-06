extends WaveState
class_name ActiveState

var slime = preload("res://enemy/Enemy.tscn") 
var witch = preload("res://enemy/WitchEnemy.tscn")

var currentWave : int = 0
var enemyList : Array 

#Every time the ActiveState WaveState starts being the current state,
#it increments the current wave by one, and uses the formula in calculateWavePoints()
#to determine how many points to use when buying enemies. That point total is
#then passed to buyEnemies(), which returns a list of enemy names as strings.
func Enter():
	currentWave += 1
	enemyList = buyEnemies(calculateWavePoints(currentWave))
	#print("Entered wave " + str(currentWave) + " with " + str(calculateWavePoints(currentWave)) + " points purchasing the following enemies: " + str(enemyList))
	spawnEnemies(enemyList)

# Every frame, this checks if there are no remaining spawned enemies (node group 
#"ENEMIES") and there are no enemies that haven't spawned yet (enemyList == 0).
#If both are at 0, it sends a signal to the Wavemachine to switch to InactiveState
func Update(delta):
	if get_tree().get_nodes_in_group("ENEMIES").size() == 0 && len(enemyList) == 0:
		Transition.emit(self, "InactiveState")

#This formula is simple af, and can be tweaked later
func calculateWavePoints(waveCount):
	return 5 + (2 * (waveCount-1))


func buyEnemies(points):
	var enemiesPurchased = []
	var enemies = {
	"Slime": 1,
	"Witch": 3
	}
	var affordableEnemies = []
	
	#
	for enemy in enemies.keys():
		if enemies[enemy] <= points:
			affordableEnemies.append(enemy)

	while points > 0:

		# If there's no more affordable monsters, break out of the loop
		if len(affordableEnemies) == 0:
			break

		var chosenEnemy = affordableEnemies[randi() % len(affordableEnemies)]
		enemiesPurchased.append(chosenEnemy)
		points -= enemies[chosenEnemy]
	
	return enemiesPurchased

func spawnEnemies(enemyList):
	while len(enemyList) > 0:
		var enemy = enemyList[0]
		await(get_tree().create_timer(1.0).timeout)
		var newEnemy
		if enemy == "Slime":
			newEnemy = slime.instantiate()
		elif enemy == "Witch":
			newEnemy = witch.instantiate()
		get_tree().get_root().get_node("PlayerTesting").add_child(newEnemy)
		newEnemy.add_to_group("ENEMIES")
		newEnemy.global_position = getRandomPoint()
		enemyList.remove_at(0)

func getRandomPoint():
	var gameAreaCornerVectors2D = (get_tree().get_root().get_node("PlayerTesting/Game_Space")).find_child("MapArea", true, true).get_polygon()
	
	#Convert local vectors to global vectors
	for vector in gameAreaCornerVectors2D:
		var result = Vector2(vector[0], vector[1]) * Vector2(((get_tree().get_root().get_node("PlayerTesting")).find_child("Game_Space", true, true)).global_scale)
		result = result + Vector2((get_tree().get_root().get_node("PlayerTesting/Game_Space")).find_child("MapArea", true, true).global_position)
		gameAreaCornerVectors2D.set(gameAreaCornerVectors2D.find(vector), result)
	
	#Initialize the min and max coordinates with the first vector values
	var min_x = gameAreaCornerVectors2D[0].x
	var min_y = gameAreaCornerVectors2D[0].y
	var max_x = gameAreaCornerVectors2D[0].x
	var max_y = gameAreaCornerVectors2D[0].y

	# Iterate through the vectors to find the actual min and max coordinates
	for vector in gameAreaCornerVectors2D:
		min_x = min(min_x, vector.x)
		min_y = min(min_y, vector.y)
		max_x = max(max_x, vector.x)
		max_y = max(max_y, vector.y)

	# Apply buffer to the coordinates so enemies don't spawn on top of walls
	var buffer = 300
	min_x += buffer
	min_y += buffer
	max_x -= buffer
	max_y -= buffer

	# Ensure that after applying the buffer the min is still less than max
	if min_x >= max_x or min_y >= max_y:
		print("Error: Buffer is too large or vectors are too close!")
		return Vector2()

	# Generate a random point between the buffered coordinates
	var random_x = randf() * (max_x - min_x) + min_x
	var random_y = randf() * (max_y - min_y) + min_y

	return Vector2(random_x, random_y)	
