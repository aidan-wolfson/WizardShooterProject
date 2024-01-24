extends TextureProgressBar

@onready var player = (get_tree().get_root().get_node("PlayerTesting")).find_child("Player", true, true)

var new_hp
var tween

func _ready():
	player.health_changed.connect(update) # connect the update function to this signal
	value = 100

func update():
	new_hp = player.CURRENT_HP * 100 / player.MAX_HP
	tween = get_tree().create_tween()
	tween.tween_property(self, 'value', new_hp, 0.3)
