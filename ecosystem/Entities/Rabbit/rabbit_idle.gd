extends State
class_name RabbitIdle 

var idle_timer = 0.0
@export var search_state : RabbitSearch
@export var hide_state : RabbitHide

func process_physics(delta):
	idle_timer -= delta
	print(idle_timer)
	if parent.sleep_timer <= 0:
		return hide_state
	if idle_timer <= 0.0:
		return search_state
	return null


func enter():
	parent.label.text = "Idle"
	idle_timer = randf_range(1.0, 3.0)
