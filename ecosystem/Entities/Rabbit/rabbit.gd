extends CharacterBody2D
class_name Rabbit

@export var sleep_timer : float = 35
@export var death_timer : float = 500
var mate_timer : float = 25


var home_tile : Vector2i


@export var level_manager : LevelManager
@export var entity_manager : EntityManager

@onready var state_machine = $StateMachine
@export var death_state : Death
@export var mate_state : RabbitMating

@export var stats : CreatureStats

@onready var label = $Label

var is_moving = false
var is_hungry = true
var is_mating = false
var is_highlighted = false
var current_path : Array[Vector2i]
var current_point_path

var tile_highlights = []


var hide_places = []
var food_growths = []

func _ready():
	sleep_timer = randf_range(35.0, 50.0)
	add_to_group("actors")
	entity_manager.add_to_mammals(self)
	state_machine.init(self, level_manager, entity_manager)
	var current_tile = level_manager.tile_map.local_to_map(global_position)
	global_position = level_manager.tile_map.map_to_local(current_tile)
	
	Global.connect("herbi_highlight", highlight)
	Global.connect("remove_label", hide_label)
	
	var mat = $Sprite2D.material
	if mat and mat is ShaderMaterial:
		mat.set_shader_parameter("highlight_enabled", false)


func _physics_process(delta: float) -> void:
	if Global.is_paused:
		return
	
	
	sleep_timer -= delta
	death_timer -= delta
	
	
	if death_timer <= 0:
		state_machine.change_state(death_state)
	
	state_machine.process_physics(delta)

func process_gender_for_mating():
	match stats.gender:
		true:
			state_machine.change_state(mate_state)
		false:
			is_mating = true 


func move() -> bool:
	if current_path.is_empty():
		return true
	
	var target_position = level_manager.convert_path(current_path.front())
	
	global_position = global_position.move_toward(target_position, 1.5)
	
	if global_position == target_position:
		var current_path_tile = current_path.pop_front()
		Global.output_data['distance_traveled_rabbits'] += 1
		
		#if is_mating:
			#level_manager.tile_map.drop_pheromone(current_path_tile, self)
	
	return current_path.is_empty()

func drop_pheromone():
	pass


func set_hungry():
	is_hungry = !is_hungry

func execute_action():
	print("Attacking")
	pass

func hide_label():
	label.visible = not label.visible

func highlight(i : int):
	var mat = $Sprite2D.material
	if mat and mat is ShaderMaterial:
		mat.set_shader_parameter("highlight_enabled", !is_highlighted)
		is_highlighted = !is_highlighted
