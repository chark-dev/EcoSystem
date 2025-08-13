extends Control


var is_open : bool = false
var current_type : int = -1 

@onready var num_label = $ColorRect/ScrollContainer/Label


@export var entity_manager : EntityManager


func _ready() -> void:
	Global.connect("beetle_highlight", open)
	Global.connect("herbi_highlight", open)
	Global.connect("snake_highlight", open)


func open(type: int):
	if is_open and type == current_type:
		visible = false
		is_open = false
		current_type = -1
		return
	
	visible = true
	is_open = true
	current_type = type
	
	
	match type:
		0:
			process_beetle_data()
		1:
			process_herbi_data()
		2:
			process_snake_data()



func process_beetle_data():
	num_label.text = ""
	var num_data = entity_manager.get_beetle_count()
	var mating_data = entity_manager.get_beetle_mating()
	num_label.text += 'Num of Beetles: ' + num_data + "\n"
	
	num_label.text += "Beetles Born: " + str(Global.output_data['beetles_born']) + "\n"
	num_label.text += "Beetles Died: " + str(Global.output_data['dead_beetles']) + "\n"
	num_label.text += "Beetles Max Pop: " + str(Global.output_data['max_population_beetles']) + "\n"
	num_label.text += "Beetles Lowest Pop: " + str(Global.output_data['lowest_population_beetles']) + "\n"
	num_label.text += "Food Eaten: " + str(Global.output_data['food_eaten_beetles']) + "\n"
	num_label.text += "Pheromones Dropped: " + str(Global.output_data['beetle_pheromones_dropped']) + "\n"
	num_label.text += "Distance Travelled: " + str(Global.output_data['distance_traveled_beetles']) + "\n"
	
	
	
func process_herbi_data():
	num_label.text = ""
	var num_data = entity_manager.get_herbi_count()
	var mating_data = entity_manager.get_herbi_mating()
	num_label.text += 'Num of Rabbits: ' + num_data + "\n"
	
	num_label.text += "Beetles Born: " + str(Global.output_data['rabbits_born']) + "\n"
	num_label.text += "Beetles Died: " + str(Global.output_data['dead_rabbits']) + "\n"
	num_label.text += "Beetles Max Pop: " + str(Global.output_data['max_population_rabbits']) + "\n"
	num_label.text += "Beetles Lowest Pop: " + str(Global.output_data['lowest_population_rabbits']) + "\n"
	num_label.text += "Food Eaten: " + str(Global.output_data['food_eaten_rabbits']) + "\n"
	num_label.text += "Pheromones Dropped: " + str(Global.output_data['rabbit_pheromones_dropped']) + "\n"
	num_label.text += "Distance Travelled: " + str(Global.output_data['distance_traveled_rabbits']) + "\n"

func process_snake_data():
	num_label.text = ""
	var num_data = entity_manager.get_snake_count()
	var mating_data = entity_manager.get_snake_mating()
	num_label.text += 'Num of Snakes: ' + num_data + "\n"
	
	num_label.text += "Snakes Born: " + str(Global.output_data['snakes_born']) + "\n"
	num_label.text += "Snakes Died: " + str(Global.output_data['dead_snakes']) + "\n"
	num_label.text += "Snakes Max Pop: " + str(Global.output_data['max_population_snakes']) + "\n"
	num_label.text += "Snakes Lowest Pop: " + str(Global.output_data['lowest_population_snakes']) + "\n"
	num_label.text += "Rabbits Eaten: " + str(Global.output_data['rabbits_eaten_by_snakes']) + "\n"
	num_label.text += "Pheromones Dropped: " + str(Global.output_data['snake_pheromones_dropped']) + "\n"
	num_label.text += "Distance Travelled: " + str(Global.output_data['distance_traveled_snakes']) + "\n"
