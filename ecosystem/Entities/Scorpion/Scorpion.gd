extends CharacterBody2D
class_name Scorpion 

@export var level_manager : LevelManager
@onready var state_machine = $StateMachine
@export var stats : CreatureStats

@onready var label = $Label

var is_moving = false
var current_path : Array[Vector2i]
var current_point_path

func _ready():
	state_machine.init(self, level_manager)


func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)


func move():
	if current_path.is_empty():
		return
	
	var target_position = get_parent().convert_path(current_path.front())
	
	global_position = global_position.move_toward(target_position, 1)
	
	if global_position == target_position:
		current_path.pop_front()
