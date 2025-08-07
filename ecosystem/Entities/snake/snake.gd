extends CharacterBody2D
class_name Snake 



@export var sleep_timer : float = 35
@export var death_timer : float = 500
@export var body : Body



@export var level_manager : LevelManager
@export var entity_manager : EntityManager

@onready var state_machine = $StateMachine
@export var death_state : Death

@export var stats : CreatureStats

@onready var label = $Label

var is_moving = false
var current_path : Array[Vector2i]
var current_point_path

var tile_highlights = []
var hide_places = []

func _ready():
	add_to_group("actors")
	state_machine.init(self, level_manager, entity_manager)
	var current_tile = level_manager.tile_map.local_to_map(global_position)
	global_position = level_manager.tile_map.map_to_local(current_tile)


func _physics_process(delta: float) -> void:
	if Global.is_paused:
		return 
	
	
	
	sleep_timer -= delta
	death_timer -= delta
	
	if death_timer <= 0:
		state_machine.change_state(death_state)
	
	state_machine.process_physics(delta)




func move() -> bool:
	if current_path.is_empty():
		return true
	
	var target_position = level_manager.convert_path(current_path.front())
	
	body.target_pos = target_position
	
	global_position = global_position.move_toward(target_position, 1)
	
	if global_position == target_position:
		current_path.pop_front()
	
	return current_path.is_empty()





func execute_action():
	print("Attacking")
	pass
