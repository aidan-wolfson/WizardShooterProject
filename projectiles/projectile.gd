extends Area2D

@export var speed: int = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += speed * direction * delta

func destroy():
	queue_free()

func _on_body_entered(body):
	destroy() # destroy projectile

func _on_area_entered(area):
	destroy() # destroy projectile 

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free() # delete the projectile once off-screen