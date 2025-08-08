extends State
class_name RabbitHide

@export var search_range : int
@export var sleep_state : RabbitSleeping

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
	parent.label.text = "Hiding"
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
		return level_manager.tile_map.local_to_map(parent.global_position)
	
	var current_tile := level_manager.tile_map.local_to_map(parent.global_position)
	var closest_tile : Vector2i = parent.hide_places[-1]
	
	var shortest_distance := current_tile.distance_to(closest_tile)
	
	
	for tile in parent.hide_places:
		var distance := current_tile.distance_to(tile)
		if distance < shortest_distance:
			shortest_distance = distance
			closest_tile = tile
	
	return closest_tile
