extends State
class_name CreateHome


@export var idle_state : RabbitIdle
var has_created_home = false

func process_physics(delta):
	if has_created_home:
		return idle_state

func enter():
	create_home()

func exit():
	has_created_home = false

func create_home():
	var home_tile = parent.level_manager.tile_map.local_to_map(parent.position)
	parent.home_tile = home_tile
	print(parent.home_tile)
	
	await get_tree().create_timer(10)
	
	has_created_home = true
