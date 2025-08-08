extends State
class_name PheromonePatrol

@export var idle_state : Idle
@export var hide_state : Hide

var mating = false

var current_path_tile
var patrol_tiles := []
var current_target_pos := Vector2.ZERO
var center_tile := Vector2i.ZERO
var center_position := Vector2.ZERO
var returning_home := false

var mate_timer : float = 20

var search_range : int 

func enter():
	search_range = parent.stats.pheromone_range
	print('Entering Pheromone State')
	parent.label.text = 'Pheromone'
	
	
	center_tile = level_manager.tile_map.local_to_map(parent.global_position)
	center_position = level_manager.tile_map.map_to_local(center_tile)
	
	# Get patrol tiles
	patrol_tiles.clear()
	for x in range(-search_range, search_range + 1):
		for y in range(-parent.stats.search_range, parent.stats.search_range + 1):
			var offset = Vector2i(x, y)
			if offset.length() > search_range:
				continue
			var tile = center_tile + offset
			if not level_manager.astar_grid.is_point_solid(tile):
				patrol_tiles.append(tile)
	
	#patrol_tiles.shuffle()
	
	print('Patrol Tiles: ', patrol_tiles)

	# Set up path to first tile
	set_next_patrol_target()

func exit():
	mating = false
	mate_timer = 20

func process_physics(delta):
	
	mate_timer -= delta
	
	if mate_timer <= 0:
		parent.mate_timer = 30
		return idle_state
	
	if mating:
		return_and_reproduce()
	# Wait until movement is finished
	if parent.move():
		# Movement complete — we're on the target tile

		# If returning to center, rest and finish
		if returning_home:
			rest_for_mate()

		# Drop pheromone at the tile we just arrived at
		level_manager.tile_map.drop_pheromone(current_path_tile, parent)

		# Continue patrol
		if patrol_tiles.size() > 0:
			set_next_patrol_target()
		else:
			# No more patrol tiles — return to center
			var path = level_manager.get_actor_path(parent.global_position, center_position)
			parent.current_path = path
			returning_home = true

	return null  # No state change unless resting

func set_next_patrol_target():
	var next_tile = patrol_tiles.pop_front()
	current_path_tile = next_tile
	var target_pos = level_manager.tile_map.map_to_local(next_tile)
	var path = level_manager.get_actor_path(parent.global_position, target_pos)
	parent.current_path = path


func rest_for_mate():
	pass



func return_and_reproduce():
	parent.has_mated = true
	mating = false
	hide_state.has_eggs = true
	
	parent.state_machine.change_state(hide_state)
