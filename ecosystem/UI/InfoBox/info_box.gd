extends Control


var is_open : bool = false

@onready var num_label = $ColorRect/VBoxContainer/Label
@onready var mating_label = $ColorRect/VBoxContainer/Label2

@export var entity_manager : EntityManager


func _ready() -> void:
	Global.connect("beetle_highlight", open)
	Global.connect("herbi_highlight", open)
	Global.connect("snake_highlight", open)


func open(type: int):
	is_open = !is_open
	visible = is_open  # same as show/hide in one line
	
	match type:
		0:
			process_beetle_data()
		1:
			process_herbi_data()
		2:
			process_snake_data()



func process_beetle_data():
	num_label.text = ""
	mating_label.text = ""
	var num_data = entity_manager.get_beetle_count()
	var mating_data = entity_manager.get_beetle_mating()
	num_label.text += 'Num of Beetles: ' + num_data
	mating_label.text += 'Mating potential: ' + mating_data

func process_herbi_data():
	num_label.text = ""
	mating_label.text = ""
	var num_data = entity_manager.get_herbi_count()
	var mating_data = entity_manager.get_herbi_mating()
	num_label.text += 'Num of Herbivores: ' + num_data
	mating_label.text += 'Mating potential: ' + mating_data

func process_snake_data():
	num_label.text = ""
	mating_label.text = ""
	var num_data = entity_manager.get_snake_count()
	var mating_data = entity_manager.get_snake_mating()
	num_label.text += 'Num of Snakes: ' + num_data
	mating_label.text += 'Mating potential: ' + mating_data
