extends State
class_name RabbitFeed 

var food_position : Vector2i

@export var idle_state : RabbitIdle

func enter():
	parent.label.text = "Feed"
	feed()


func exit():
	food_position = Vector2i()
	for poly in parent.tile_highlights:
		if poly:
			poly.queue_free()
	parent.tile_highlights.clear()


func process_physics(delta):
	
#	Think I need to change this to be local position as it stops as soon as it gets into the square. 
	if parent.global_position == level_manager.tile_map.map_to_local(food_position):
		eat_food_at_tile(food_position)
		# EAT FOOD 
		return idle_state
	
	
	parent.move()

func feed():
	var target_position = level_manager.tile_map.map_to_local(food_position) 
	
	var path = level_manager.get_actor_path(parent.global_position, target_position)
	
	if path.is_empty() == false:
		parent.current_path = path


func eat_food_at_tile(tile_pos: Vector2i) -> void:
	var tile_world_pos = level_manager.tile_map.map_to_local(tile_pos)
	
	parent.food_growths.append(tile_pos)

	# Use the food_map directly
	for i in range(level_manager.tile_map.food_map.size()):
		var entry = level_manager.tile_map.food_map[i]
		if entry["tile"] == tile_pos:
			entry["node"].queue_free()
			print("Removed Food.")
			level_manager.tile_map.food_map.remove_at(i)
			parent.stats.hunger -= 1
			
			if parent.stats.hunger <= 0:
				parent.set_hungry()
			
			print("Rabbit ate food at ", tile_pos)

			# 🧼 Remove smells associated with this food tile
			var smells_to_remove = []
			for smell in level_manager.tile_map.smell_map:
				if smell.food_source_tile == tile_pos:
					smells_to_remove.append(smell)

			for smell in smells_to_remove:
				level_manager.tile_map.smell_map.erase(smell)
				smell.queue_free()

			break
