extends TextureProgressBar

@onready var player = (get_tree().get_root().get_node("PlayerTesting")).find_child("Player", true, true)

var tween 
var new_stamina

func _ready():
	player.stamina_changed.connect(update) # connect the update function to this signal
	value = 100

func update():
	new_stamina = player.DODGE_STAMINA * 100 / 100
	tween = get_tree().create_tween()
	tween.tween_property(self, 'value', new_stamina, 0.3)
	# value = player.DODGE_STAMINA * 100 / 100
