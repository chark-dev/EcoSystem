extends Node

var is_paused : bool = false

signal turn_complete
signal beetle_highlight(num)
signal herbi_highlight(num)
signal snake_highlight(num)
signal hatch_egg(position)

signal time_tick(day: int, hour: int, minute: int)
signal day_passed(day : int)
signal hour_passed(hour : int)

@onready var main_scene = preload("res://Stages/procedural_test/procedural_test.tscn")
@onready var results_scene = preload("res://UI/Results/results_scene.tscn")
@onready var day_passed_dialog_scene = preload("res://UI/Confimation/confirmation_dialog.tscn")
var day_passed_dialog : ConfirmationDialog = null


var ecosystem_data : Dictionary

var current_seed 


var output_data = {
	'beetle_eggs' : 0,
	'dead_beetles' : 0,
	'dead_rabbits' : 0,
	'dead_snakes' : 0,
	'food_dropped' : 0
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
	
