extends State
class_name SnakeSearch 


@export var feed_state : Hunt
@export var idle_state : SnakeIdle

@export var search_range : int

var found_food : bool 

var search_directions = [
	Vector2i(1, 0),   # East
	Vector2i(-1, 0),  # West
	Vector2i(0, 1),   # South
	Vector2i(0, -1),  # North
	Vector2i(1, 1),   # SE
	Vector2i(-1, -1), # NW
	Vector2i(1, -1),  # NE
	Vector2i(-1, 1),  # SW
]

func process_physics(delta):
	if found_food:
		return feed_state
	
	if parent.current_path.is_empty():
		return idle_state
	
	parent.move()
	
	
	return null

func enter():
	parent.label.text = "Search"
	found_food = false
	search()

func exit():
	for poly in parent.tile_highlights:
		if poly:
			poly.queue_free()
	parent.tile_highlights.clear()

func search():
	var current_pos = level_manager.tile_map.local_to_map(parent.global_position)
	var target_tiles = []

	for x in range(-search_range, search_range + 1):
		for y in range(-search_range, search_range + 1):
			var offset = Vector2i(x, y)
			var tile = current_pos + offset
			# Optional: skip out-of-range tiles if using circular search
			if offset.length() > search_range:
				continue
			for smell in level_manager.tile_map.mammal_smell_map:
				var smell_tile = level_manager.tile_map.local_to_map(smell.position)
				if smell_tile == tile:
					feed_state.food_position = smell.food_source_tile
					found_food = true
					break
			
#			 Here add for loop to check if mammal is in Search radius 
					
			if not level_manager.astar_grid.is_point_solid(tile):
				target_tiles.append(tile)

	parent.tile_highlights = level_manager.highlight_tiles(target_tiles)

	if target_tiles.size() > 0:
		var target_position = level_manager.tile_map.map_to_local(target_tiles.pick_random())
		var path = level_manager.get_actor_path(parent.global_position, target_position)
		if not path.is_empty():
			parent.current_path = path
