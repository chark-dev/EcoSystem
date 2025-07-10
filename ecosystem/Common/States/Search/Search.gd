extends State 
class_name Search

@export var feed_state : Feed
@export var idle_state : Idle

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

func search():
	var current_pos = level_manager.tile_map.local_to_map(parent.global_position)
	
	var target_tiles = []
	
	for dir in search_directions:
		var tile = current_pos + dir * search_range
		if not level_manager.astar_grid.is_point_solid(tile):
			target_tiles.append(tile)
	
	print(target_tiles)
	
	level_manager.highlight_tiles(target_tiles)
	
	var target_position = level_manager.tile_map.map_to_local(target_tiles.pick_random()) 
	
	var path = level_manager.get_actor_path(parent.global_position, target_position)
	
	if path.is_empty() == false:
		parent.current_path = path
