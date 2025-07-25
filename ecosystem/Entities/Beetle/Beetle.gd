extends CharacterBody2D
class_name Beetle

enum TurnState { IDLE, MOVING, ACTING }
var turn_state : TurnState = TurnState.IDLE


@export var level_manager : LevelManager
@onready var state_machine = $StateMachine
@export var utility_ai : UtilityAI
@export var stats : CreatureStats

@onready var label = $Label

var is_moving = false
var current_path : Array[Vector2i]
var current_point_path

func _ready():
	add_to_group("actors")
	state_machine.init(self, level_manager)
	utility_ai.init(self)
	var current_tile = level_manager.tile_map.local_to_map(global_position)
	global_position = level_manager.tile_map.map_to_local(current_tile)


func _physics_process(delta: float) -> void:
	#match turn_state:
		#TurnState.MOVING:
			#var finished = move()
			#if finished:
				#turn_state = TurnState.ACTING
		#
		#TurnState.ACTING:
			#execute_action()
			#SignalBus.turn_complete.emit()
			#print("Beetle emitted turn_complete")
			#turn_state = TurnState.IDLE  # Reset for next turn
	
	if level_manager.combat:
		return
	
	state_machine.process_physics(delta)




func move() -> bool:
	if current_path.is_empty():
		return true
	
	var target_position = level_manager.convert_path(current_path.front())
	
	global_position = global_position.move_toward(target_position, 1)
	
	if global_position == target_position:
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
