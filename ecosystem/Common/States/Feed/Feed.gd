extends State
class_name Feed 

var food_position : Vector2i

@export var idle_state : Idle

func enter():
	parent.label.text = "Feed"
	feed()


func exit():
	food_position = Vector2i()


func process_physics(delta):
	
#	Think I need to change this to be local position as it stops as soon as it gets into the square. 
	if level_manager.tile_map.local_to_map(parent.global_position) == food_position:
		return idle_state
	
	
	parent.move()

func feed():
	var target_position = level_manager.tile_map.map_to_local(food_position) 
	
	var path = level_manager.get_actor_path(parent.global_position, target_position)
	
	if path.is_empty() == false:
		parent.current_path = path
