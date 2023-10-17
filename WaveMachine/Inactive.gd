extends WaveState
class_name InactiveState

func Enter():
	print("Entered Inactvie Wave State, restarting wave in 3 seconds")
	await get_tree().create_timer(3.0).timeout
	Transition.emit(self, "ActiveState")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func Update(delta):
	pass
