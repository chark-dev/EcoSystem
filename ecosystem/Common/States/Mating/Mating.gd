extends State
class_name Mating

var mate : Beetle = null
var mating : bool = false
var search_range : int 
@export var idle_state : Idle

func enter():
	parent.label.text = 'Mating: Male'
	
	search_for_mate()
	



func exit():
	mating = false
	for poly in parent.tile_highlights:
		if poly:
			poly.queue_free()
	parent.tile_highlights.clear()

func process_physics(delta):
	if mate:
		if level_manager.tile_map.local_to_map(parent.global_position) == level_manager.tile_map.local_to_map(mate.global_position):
			mate_with_partner()
		
	
	
	parent.move()
	
	if parent.current_path.is_empty() and !mating:
		return idle_state
	
	return null



func search_for_mate():
	search_range = parent.stats.search_range
	var current_pos = level_manager.tile_map.local_to_map(parent.global_position)
	var target_tiles = []
	
	
	for x in range(-search_range, search_range + 1):
		for y in range(-search_range, search_range + 1):
			var offset = Vector2i(x, y)
			var tile = current_pos + offset
			# Optional: skip out-of-range tiles if using circular search
			if offset.length() > search_range:
				continue
			
			for pheromone in level_manager.tile_map.pheromone_map:
				if pheromone.source is Beetle:
					var p_tile = pheromone.tile_pos
					if p_tile == tile:
						
						mating = true
						mate = pheromone.source
						
						var path = level_manager.get_actor_path(parent.global_position, pheromone.source.global_position)
						
						if not path.is_empty():
							parent.current_path = path
							return
	
			if not level_manager.astar_grid.is_point_solid(tile):
				target_tiles.append(tile)
				
	parent.tile_highlights = level_manager.highlight_tiles(target_tiles)
	
	if target_tiles.size() > 0:
		var target_position = level_manager.tile_map.map_to_local(target_tiles.pick_random())
		var path = level_manager.get_actor_path(parent.global_position, target_position)
		if not path.is_empty():
			parent.current_path = path
		



func mate_with_partner():
	print('Mating with partner.')
	parent.has_mated = true
	if mate:
		mate.set_mating()
	
	await get_tree().create_timer(5).timeout
	
	
	parent.state_machine.change_state(idle_state)
