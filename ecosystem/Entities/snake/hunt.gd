extends State 
class_name Hunt 

@export var idle_state : SnakeIdle

var search_range = 3

var closest_distance = INF
var closest_mammal

var attacking = false 


var attack_timer : float = 5


# Follow Smell Trail to Mammal. 
# Ambush while sleeping. 

func process_physics(delta):
	attack_timer -= delta
	
	if attack_timer <= 0:
		return idle_state
	
	if attacking:
		parent.move()
		check_for_collision()
	
	


func enter():
	parent.label.text = 'Hunt'
	
	trap_prey()

func exit():
	parent.speed = 1
	attacking = false 



func trap_prey():
	var current_pos = level_manager.tile_map.local_to_map(parent.global_position)
	var target_tiles = []

	for x in range(-search_range, search_range + 1):
		for y in range(-search_range, search_range + 1):
			var offset = Vector2i(x, y)
			var tile = current_pos + offset
			# Optional: skip out-of-range tiles if using circular search
			if offset.length() > search_range:
				continue
			attack_prey()


func attack_prey():
	var path_to_prey = level_manager.get_actor_path(parent.global_position, parent.closest_mammal.global_position)
	
	if path_to_prey:
		parent.speed = 5
		attacking = true 
		parent.current_path = path_to_prey
		parent.collision_area.monitoring = true


func check_for_collision():
#	
	var bodies = parent.collision_area.get_overlapping_bodies()
	
	if parent.closest_mammal and bodies.has(parent.closest_mammal):
		print('Killed: ', parent.closest_mammal)
		Global.output_data['rabbits_eaten_by_snakes'] += 1
		Global.output_data['dead_rabbits'] += 1
		Global.emit_signal("creature_died", 'rabbit')
		attacking = false
		parent.entity_manager.mammals.erase(parent.closest_mammal)

		for poly in parent.closest_mammal.tile_highlights:
			if poly:
				poly.queue_free()
			parent.closest_mammal.tile_highlights.clear()
			
			
		parent.closest_mammal.queue_free()
		
		parent.closest_mammal = null
		
		parent.collision_area.monitoring = false
		
		parent.is_hungry = false
