extends Node2D
# class to manage game states and UI scenes

const GameOverScreen = preload("res://UI/game_over_screen.tscn")

@onready var player = $Player

func _ready():
	# connect all player signals
	if player:
		player.player_died.connect(handle_player_loss)


func handle_player_loss():
	var game_over = GameOverScreen.instantiate()
	add_child(game_over)
	get_tree().paused = true
