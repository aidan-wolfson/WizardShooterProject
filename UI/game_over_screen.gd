extends CanvasLayer




func _on_restart_pressed():
	get_tree().change_scene_to_file("res://world/world.tscn")

func _on_quit_pressed():
	# may not work for all platforms, should check to see which platform and quit accordingly
	get_tree().quit()
