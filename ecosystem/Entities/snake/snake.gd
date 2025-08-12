extends CharacterBody2D
class_name Snake 



@export var sleep_timer : float = 35
@export var death_timer : float = 500
@export var mate_timer : float = death_timer / 6
@export var speed : float = 1

@onready var collision_area : Area2D = $Area2D

var closest_mammal

@export var level_manager : LevelManager
@export var entity_manager : EntityManager

@onready var state_machine = $StateMachine
@export var death_state : Death
@export var pheromone_state : SnakePheromone
@export var mate_state : SnakeMating

@export var stats : CreatureStats

@onready var label = $Label

var is_moving = false
var is_hungry = true
var is_mating = false
var has_mated : bool = false
var is_highlighted = false
var current_path : Array[Vector2i]
var current_point_path

var tile_highlights = []
var hide_places = []

func _ready():
	sleep_timer = randf_range(35.0, 50.0)
	set_up_stats()
	add_to_group("actors")
	state_machine.init(self, level_manager, entity_manager)
	var current_tile = level_manager.tile_map.local_to_map(global_position)
	global_position = level_manager.tile_map.map_to_local(current_tile)
	
	
	Global.connect("snake_highlight", highlight)
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
	stats.search_range = 5
	stats.hunger = 1
	stats.pheromone_range = 1


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
	
	
	global_position = global_position.move_toward(target_position, speed)
	
	if global_position == target_position:
		current_path.pop_front()
	
	return current_path.is_empty()





func execute_action():
	print("Attacking")
	pass

func highlight(i : int):
	var mat = $Sprite2D.material
	if mat and mat is ShaderMaterial:
		mat.set_shader_parameter("highlight_enabled", !is_highlighted)
		is_highlighted = !is_highlighted

func hide_label():
	label.visible = not label.visible

func set_mating():
	pheromone_state.mating = true 
