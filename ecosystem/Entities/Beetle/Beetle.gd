extends CharacterBody2D
class_name Beetle


@onready var state_machine = $StateMachine
var is_moving = false
var current_path : Array[Vector2i]
var current_point_path
@onready var label = $Label
@export var level_manager : LevelManager


func _ready():
	state_machine.init(self, level_manager)


func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var click_pos = get_global_mouse_position()
			
			var path = get_parent().get_actor_path(global_position, click_pos)
			
			if path.is_empty() == false:
				current_path = path
				


func move():
	if current_path.is_empty():
		return
	
	var target_position = get_parent().convert_path(current_path.front())
	
	global_position = global_position.move_toward(target_position, 1)
	
	if global_position == target_position:
		current_path.pop_front()
