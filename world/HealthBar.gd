extends TextureProgressBar

@onready var player = (get_tree().get_root().get_node("PlayerTesting")).find_child("Player", true, true)

func _ready():
	player.health_changed.connect(update) # connect the update function to this signal
	value = 100

func update():
	value = player.CURRENT_HP * 100 / player.MAX_HP
