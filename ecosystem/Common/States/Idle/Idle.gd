extends State
class_name Idle 

var idle_timer = 0.0
@export var search_state : Search

func process_physics(delta):
	idle_timer -= delta
	print(idle_timer)
	if idle_timer <= 0.0:
		return search_state
	return null


func enter():
	parent.label.text = "Idle"
	idle_timer = randf_range(1.0, 3.0)
