extends Node
class_name StateMachine

@export var start_state: State
var current_state : State 

 

func init(parent: CharacterBody2D):
	for child in get_children():
		child.parent = parent
#		Any other data to be passed to states goes here. 
	
	change_state(start_state)


#Change to a new state, call exit state on current state then enter on new state 
func change_state(new_state : State):
	if current_state:
		current_state.exit()
		
		current_state = new_state
		current_state.enter()

func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)

func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)
