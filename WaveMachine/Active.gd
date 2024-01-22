extends WaveState
class_name ActiveState

var slime = preload("res://enemy/Enemy.tscn") 
var witch = preload("res://enemy/WitchEnemy.tscn")

@onready var upgradeScreen = get_tree().get_root().get_node("PlayerTesting/CanvasLayer/UpgradeScreen")

var currentWave : int = 0
var enemyList : Array 

var alreadyEnded : bool = false

func _ready():
	enter()

func enter():
	alreadyEnded = false
	currentWave += 1
	print_debug("Starting wave " + str(currentWave))
	enemyList = buyEnemies(calculateWavePoints(currentWave))
	#print("Entered wave " + str(currentWave) + " with " + str(calculateWavePoints(currentWave)) + " points purchasing the following enemies: " + str(enemyList))
	spawnEnemies(enemyList)

func end():
	upgradeScreen.startUpgrade()
	print_debug("Wave ended, starting new wave")
	

# Every frame, this checks if there are no remaining spawned enemies (node group 
#"ENEMIES") and there are no enemies that haven't spawned yet (enemyList == 0).
#If both are at 0, it sends a signal to the Wavemachine to switch to InactiveState
func _process(delta):
	if get_tree().get_nodes_in_group("ENEMIES").size() == 0 and len(enemyList) == 0 and !alreadyEnded:
		alreadyEnded = true
		end()

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
	var gameAreaScale = get_tree().get_root().get_node("PlayerTesting/Game_Space").scale
	var gameAreaShape = (((get_tree().get_root().get_node("PlayerTesting/Game_Space/MapArea/CollisionShape2D")).get_shape().size)/2)*gameAreaScale
	
	return Vector2(randf_range(-gameAreaShape.x, gameAreaShape.x), randf_range(-gameAreaShape.y, gameAreaShape.y))	
