extends Node2D

var playerInRange : bool = false
var spritePath : String 
@onready var pressE = $RichTextLabel
var opened : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pressE.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if pressE.visible and Input.is_action_just_pressed("interact") and opened == false:
		print("Just interacted!")
		self.opened = true
		$AnimationPlayer.play("Open")

func _on_in_range_area_entered(area):
	if area.find_parent("Player") and opened == false:
		pressE.visible = true


func _on_in_range_area_exited(area):
	pressE.visible = false

