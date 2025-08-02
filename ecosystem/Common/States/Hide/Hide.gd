extends State
class_name Hide

@export var search_range : int
@export var sleep_state : Sleeping

var found_food : bool 

var target_hide_tile : Vector2i

@export var food_amount_for_hide : int

func process_physics(delta):
	if parent.global_position == level_manager.tile_map.map_to_local(target_hide_tile):
		print('hiding')
		parent.hide()
		return sleep_state
		
	parent.move()
	print("I am a beetle")
	return null

func enter():
	var tile = get_closest_hide_tile()
	if tile:
		target_hide_tile = tile
	hide()
	pass

func hide():
	var target_position = level_manager.tile_map.map_to_local(target_hide_tile) 
	
	var path = level_manager.get_actor_path(parent.global_position, target_position)
	
	if path.is_empty() == false:
		parent.current_path = path

func get_closest_hide_tile():
	if parent.hide_places.is_empty():
		return null
	
	var current_tile := level_manager.tile_map.local_to_map(parent.global_position)
	var closest_tile : Vector2i = parent.hide_places[0]
	
	var shortest_distance := current_tile.distance_to(closest_tile)
	
	
	for tile in parent.hide_places:
		var distance := current_tile.distance_to(tile)
		if distance < shortest_distance:
			shortest_distance = distance
			closest_tile = tile
	
	return closest_tile



# Change to search for hiding places. 
#func search():
	#var current_pos = level_manager.tile_map.local_to_map(parent.global_position)
	#var target_tiles = []
#
	#for x in range(-search_range, search_range + 1):
		#for y in range(-search_range, search_range + 1):
			#var offset = Vector2i(x, y)
			#var tile = current_pos + offset
			## Optional: skip out-of-range tiles if using circular search
			#if offset.length() > search_range:
				#continue
			#for smell in level_manager.tile_map.smell_map:
				#var smell_tile = level_manager.tile_map.local_to_map(smell.position)
				#if smell_tile == tile:
					#feed_state.food_position = smell.food_source_tile
					#found_food = true
					#break
			#if not level_manager.astar_grid.is_point_solid(tile):
				#target_tiles.append(tile)
#
	#level_manager.highlight_tiles(target_tiles)
#
	#if target_tiles.size() > 0:
		#var target_position = level_manager.tile_map.map_to_local(target_tiles.pick_random())
		#var path = level_manager.get_actor_path(parent.global_position, target_position)
		#if not path.is_empty():
			#parent.current_path = path
