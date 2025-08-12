extends State
class_name SnakeIdle 

var idle_timer = 0.0
@export var search_state : SnakeSearch
@export var hide_state : SnakeHide

func process_physics(delta):
	idle_timer -= delta
	
	if parent.mate_timer <= 0 and idle_timer <= 0 and !parent.has_mated:
		parent.process_gender_for_mating()
		return
	
	if parent.sleep_timer <= 0:
		return hide_state
	if idle_timer <= 0.0:
		return search_state
	return null


func enter():
	parent.label.text = "Idle"
	idle_timer = randf_range(1.0, 3.0)
