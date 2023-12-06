extends CharacterBody2D

@onready var timer = $Timer
@onready var sprite = $Sprite2D

const speed = 50
var current_state = IDLE
var dir = Vector2.RIGHT
var start_pos

# basic state machine
enum {
	IDLE,
	NEW_DIR,
	MOVE,
	DIALOGUE
}

func _ready():
	randomize()
	start_pos = position

func _process(delta):
	match current_state:
		IDLE:
			pass
		NEW_DIR:
			dir = choose([Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN])
		MOVE:
			move(delta)
			handleAnimation()
	

func move(delta):
	position += dir * speed * delta

func handleAnimation():
	if dir.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

# choosing a random state
func choose(array):
	array.shuffle()
	return array.front()

func _on_timer_timeout():
	timer.wait_time = choose([0.5, 1, 1.5, 2])
	current_state = choose([IDLE, NEW_DIR, MOVE])
