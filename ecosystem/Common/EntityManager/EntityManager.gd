extends Node
class_name EntityManager

@onready var beetle_scene = preload("res://Entities/Beetle/Beetle.tscn")
@export var level_manager : LevelManager


func _ready() -> void:
	Global.connect("hatch_egg", hatch_egg)

func spawn_entities(data : Dictionary):
	pass

func get_entities():
	return get_children()


func hatch_egg(position):
	var new_beetle = beetle_scene.instantiate()
	
	
	
	new_beetle.entity_manager = self
	new_beetle.level_manager = level_manager
	
	new_beetle.global_position = position
	
	add_child(new_beetle)
