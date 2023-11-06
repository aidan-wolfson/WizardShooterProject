extends WaveState
class_name InactiveState

func Enter():
	#print("Entered Inactvie Wave State")
	pass


func becomeActive():
	Transition.emit(self, "ActiveState")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func Update(delta):
	pass
