extends Marker2D



@export var damage_node : PackedScene
@export var DAMAGE_INDICATOR: PackedScene = preload("res://UI/damage_numbers.tscn")

func _ready():
	randomize()

func popup(dmg_val : int):
	var damage_number = DAMAGE_INDICATOR.instantiate()
	damage_number.position = global_position
	
	#the following it to tween on position to random direction
	var tween = get_tree().create_tween()
	tween.tween_property(damage_number, "position", global_position + _get_direction(), 0.75)
	
	get_tree().current_scene.add_child(damage_number)
	
	if damage_number:
		damage_number.textLabel.text = str(dmg_val)
	

func _get_direction():
	# make a random vector2 with random x and y directions
	return Vector2(randf_range(-1,1), -randf()) * 16
