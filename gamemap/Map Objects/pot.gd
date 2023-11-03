extends Node2D

var destroyed : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_shooting_hb_area_entered(area):
	if destroyed == false:
		destroyed = true
		$AnimationPlayer.play("Destruct")
		var layers = [1,2,3,4]
		for layer in layers:
			$WalkingHB.set_collision_layer_value(layer, false)
			$ShootingHB.set_collision_layer_value(layer, false)
