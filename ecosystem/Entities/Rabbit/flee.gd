extends State 
class_name RabbitFlee



@export var idle_state : RabbitIdle

var has_fled : bool = false 

var predator : Snake = null 


func enter():
	parent.speed = 3
	print('fleeing')
	parent.label.text = 'Fleeing'
	find_path_to_run_to()

func exit():
	predator = null 
	parent.speed = 1.5

func process_physics(delta):
	if has_fled:
		return idle_state
	
	if parent.current_path.is_empty():
		has_fled = true
		return idle_state
	parent.move()



func find_path_to_run_to():
	if predator == null:
		has_fled = true 
	var predator_tile = level_manager.tile_map.local_to_map(predator.global_position)
	var current_pos = level_manager.tile_map.local_to_map(parent.global_position)
	var furthest_tile = current_pos
	var furthest_dist = -1
	
	for x in range(-6, 7):
		for y in range(-6, 7):
			var offset = Vector2i(x, y)
			var tile = current_pos + offset
			# Skip out-of-bounds or non-walkable tiles
			if offset.length() > 6:
				continue
			if level_manager.astar_grid.is_point_solid(tile):
				continue
			
			# Distance from predator
			var dist = predator_tile.distance_to(tile)
			if dist > furthest_dist:
				furthest_dist = dist
				furthest_tile = tile
	
	# Now move to that furthest tile
	var target_position = level_manager.tile_map.map_to_local(furthest_tile)
	var path = level_manager.get_actor_path(parent.global_position, target_position)
	
	if not path.is_empty():
		parent.current_path = path
	else:
		# If no valid path, fallback
		has_fled = true
