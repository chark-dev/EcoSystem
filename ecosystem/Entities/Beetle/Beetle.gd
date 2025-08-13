extends CharacterBody2D
class_name Beetle

enum TurnState { IDLE, MOVING, ACTING }
var turn_state : TurnState = TurnState.IDLE

@export var sleep_timer : float = randf_range(30, 35)
@export var death_timer : float = randf_range(300, 500)
var mate_timer : float = death_timer / 5

var tile_highlights: Array[Polygon2D] = []


@export var level_manager : LevelManager
@export var entity_manager : EntityManager

@onready var state_machine = $StateMachine
@export var death_state : Death
@export var mate_state : Mating
@export var pheromone_state : PheromonePatrol

@export var utility_ai : UtilityAI
var stats : CreatureStats

@onready var label = $Label

var is_moving = false
var is_hungry = true
var is_highlighted = false
var has_mated : bool = false
var current_path : Array[Vector2i]
var current_point_path


var hide_places = []

func _ready():
	sleep_timer = randf_range(35.0, 50.0)
	set_up_stats()

	add_to_group("actors")
	state_machine.init(self, level_manager, entity_manager)
	utility_ai.init(self)
	var current_tile = level_manager.tile_map.local_to_map(global_position)
	global_position = level_manager.tile_map.map_to_local(current_tile)
	Global.connect("beetle_highlight", highlight)
	Global.connect("remove_label", hide_label)
	
	var mat = $Sprite2D.material
	if mat and mat is ShaderMaterial:
		mat.set_shader_parameter("highlight_enabled", false)

func set_up_stats():
	stats = CreatureStats.new()
	stats.gender = randf() < 0.5
	stats.courage = 3
	stats.health = 3
	stats.max_health = 3
	stats.movement = 5
	stats.search_range = 3
	stats.hunger = 1
	stats.pheromone_range = 2

func _physics_process(delta: float) -> void:
	if Global.is_paused:
		return
	sleep_timer -= delta
	death_timer -= delta
	mate_timer -= delta
	
	if death_timer <= 0:
		state_machine.change_state(death_state)
	
	
	state_machine.process_physics(delta)

func process_gender_for_mating():
	match stats.gender:
		true:
			state_machine.change_state(mate_state)
		false:
			state_machine.change_state(pheromone_state)


func move() -> bool:
	if current_path.is_empty():
		return true
	
	var target_position = level_manager.convert_path(current_path.front())
	
	global_position = global_position.move_toward(target_position, 1)
	
	if global_position == target_position:
		Global.output_data['distance_traveled_beetles'] += 1
		current_path.pop_front()
	
	return current_path.is_empty()



func take_turn():
#	Get important tiles 
	var data = level_manager.get_heuristic_tiles(false, self)
	
#	Get heuristic values 
	var goal_scores = utility_ai.run_heuristics(data)
	
#	Get the correct goal 
	var selected_goal = utility_ai.select_best_goal(goal_scores)
	
#	Find the correct tile to move to
	var candidate_tiles = utility_ai.get_candidate_tiles_for_goal(selected_goal, data)
	
	
	
	
	var best_tile = utility_ai.choose_best_tile(selected_goal, candidate_tiles)
#	Move and execute action.
	if best_tile != null:
		current_path = level_manager.get_actor_path(
			global_position,
			level_manager.tile_map.map_to_local(best_tile)
		)
		current_path.pop_back()
	else:
		current_path = []
	
	print("Beetle current path: ", current_path)
	
	turn_state = TurnState.MOVING
	



func execute_action():
	print("Attacking")
	pass


func highlight(i : int):
	var should_highlight = (i == 0)
	
	is_highlighted = should_highlight
	var mat = $Sprite2D.material
	if mat and mat is ShaderMaterial:
		mat.set_shader_parameter("highlight_enabled", is_highlighted)


func hide_label():
	label.visible = not label.visible
	
	for poly in tile_highlights:
		if poly:
			poly.queue_free()
	tile_highlights.clear()

func set_mating():
	pheromone_state.mating = true 
