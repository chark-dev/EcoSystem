extends Node

var is_paused : bool = false

signal turn_complete
signal beetle_highlight(num)
signal herbi_highlight(num)
signal snake_highlight(num)
signal remove_label
signal hatch_egg(position)

signal time_tick(day: int, hour: int, minute: int)
signal day_passed(day : int)
signal hour_passed(hour : int)

signal creature_died(type : String)

@onready var main_scene = preload("res://Stages/procedural_test/procedural_test.tscn")
@onready var results_scene = preload("res://UI/Results/results_scene.tscn")
@onready var day_passed_dialog_scene = preload("res://UI/Confimation/confirmation_dialog.tscn")
var day_passed_dialog : ConfirmationDialog = null


var ecosystem_data : Dictionary

var current_seed 


var output_data = {
	'beetles_born' : 0,
	'rabbits_born' : 0,
	'snakes_born' : 0,
	'dead_beetles' : 0,
	'dead_rabbits' : 0,
	'dead_snakes' : 0,
	'food_dropped' : 0,
	'hide_places' : 0,
	'days_passed' : 0,
	'max_population_beetles' : 0,
	'max_population_rabbits' : 0,
	'max_population_snakes' : 0,
	'lowest_population_beetles' : 0,
	'lowest_population_rabbits' : 0,
	'lowest_population_snakes' : 0,
	'food_eaten_beetles' : 0,
	'food_eaten_rabbits' : 0,
	'rabbits_eaten_by_snakes' : 0,
	'beetle_pheromones_dropped' : 0,
	'rabbit_pheromones_dropped' : 0,
	'snake_pheromones_dropped' : 0,
	'distance_traveled_beetles' : 0,
	'distance_traveled_rabbits' : 0,
	'distance_traveled_snakes' : 0
}



func _ready():
	day_passed.connect(on_day_passed)
	pass

func on_day_passed(day: int):
	is_paused = true
	
	print(output_data)
	
	if day_passed_dialog == null:
		day_passed_dialog = day_passed_dialog_scene.instantiate()
		get_tree().get_root().add_child(day_passed_dialog)
		day_passed_dialog.connect("user_decision", Callable(self, "_on_day_passed_decision"))
	day_passed_dialog.popup_centered()

func _on_day_passed_decision(choice: bool):
	print("Hello, button has been pressed.")
	is_paused = not choice
	
	if !choice:
		go_to_results_screen()
	
	

func set_up_ecosystem(data : Dictionary):
	output_data['max_population_beetles'] = data['beetles_count']
	output_data['lowest_population_beetles'] = data['beetles_count']
	output_data['max_population_rabbits'] = data['rabbits_count']
	output_data['lowest_population_rabbits'] = data['rabbits_count']
	output_data['max_population_snakes'] = data['snakes_count']
	output_data['lowest_population_snakes'] = data['snakes_count']
#	check if any dict values are empty, then set defaults. 
	
	print('This is the autoload:', data)
	
	ecosystem_data = data
	
	
	if data['seed'] and str(data['seed']).is_valid_int():
		current_seed = data['seed']
		current_seed = int(current_seed)
		seed(current_seed)
		
		
		print(randi())
	else:
		randomize()
		current_seed = randi()
		seed(current_seed)
	
	
	
	
	load_main_scene()


func check_for_invalid(data: Dictionary) -> Dictionary:
	
	
	
	
	return {}


func load_main_scene():
	get_tree().change_scene_to_packed(main_scene)

func go_to_results_screen():
	get_tree().change_scene_to_packed(results_scene)

func use_slot_data(slot_data):
	print("This is the Global Script")
	print(slot_data.item_data)
	
	slot_data.item_data.use()
	
