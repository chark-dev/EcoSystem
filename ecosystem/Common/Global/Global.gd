extends Node

var is_paused : bool = false

signal turn_complete
signal beetle_highlight()



@onready var main_scene = preload("res://Stages/procedural_test/procedural_test.tscn")


var ecosystem_data : Dictionary

func set_up_ecosystem(data : Dictionary):
	
	
#	check if any dict values are empty, then set defaults. 
	
	print('This is the autoload:', data)
	
	ecosystem_data = data
	
	
	load_main_scene()


func check_for_invalid(data: Dictionary) -> Dictionary:
	
	
	
	
	return {}


func load_main_scene():
	get_tree().change_scene_to_packed(main_scene)


func use_slot_data(slot_data):
	print("This is the Global Script")
	print(slot_data.item_data)
	
	slot_data.item_data.use()
	
