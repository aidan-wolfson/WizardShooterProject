extends Node

var current_state : WaveState
var states : Dictionary = {}

func _ready():
	for child in get_children():
		if child is WaveState:
			states[child.name.to_lower()] = child
			child.Transition.connect(on_child_transition)
	
	current_state = states["InactiveState".to_lower()]
	current_state.Enter()

func _process(delta):
	current_state.Update(delta)

func on_child_transition(new_state_name):
	var new_state = states.get(new_state_name.to_lower())
	current_state.Exit()
	current_state = new_state
	current_state.Enter()
