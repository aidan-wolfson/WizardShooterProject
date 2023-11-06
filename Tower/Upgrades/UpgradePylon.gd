extends ChestObj

@export var type : String = "Damage"
var cost : int = 1


func _ready():
	pressE.visible = false
	$RichTextLabel.set_text("[center] +5 " + str (type)) 
	$RichTextLabel.newline()
	$RichTextLabel.add_text("Cost: " + str(cost))

func _process(delta):
	if pressE.visible and Input.is_action_just_pressed("interact") and player.money >= cost:
		if self.type == "Damage":
			player.changeVariable("projectileDamage", 5)
		if self.type == "Attack Speed":
			player.changeVariable("Attack Speed", -0.1)
		if self.type == "Speed":
			player.changeVariable("Speed", 50)
		player.changeVariable("Money", -cost)
		self.cost *= 2
		$RichTextLabel.text = ""
		$RichTextLabel.set_text("[center] +5 " + str (type)) 
		$RichTextLabel.newline()
		$RichTextLabel.add_text("Cost: " + str(cost))
		print("Purchased Upgrade!")

