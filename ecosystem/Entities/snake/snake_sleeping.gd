extends State
class_name SnakeSleeping

@export var awake_timer : float = 30 
@export var idle_state : SnakeIdle

@onready var egg = preload("res://Entities/Egg/egg.tscn")

var reproducing : bool = false

func process_physics(delta):
	if reproducing:
		lay_eggs()
	
	
	awake_timer -= delta
	
	if awake_timer <= 0:
		parent.show()
		return idle_state

#If food + hunger is at a certain level, + safe 
# Sleep for a while
# Process stat changes while 
# after sleep timer runs out, wake up + return to idle 
func enter():
	parent.label.text = "Sleeping"

func exit():
	parent.sleep_timer = 30
	awake_timer = 30
	parent.is_hungry = true
	
	parent.mate_timer = 200
	
	reproducing = false
	

func lay_eggs():
	reproducing = false
	
	var egg_count = 1
	
	Global.output_data['beetle_eggs'] += egg_count
	
	for i in egg_count:
		var new_egg = egg.instantiate()
		
		new_egg.level_manager = level_manager
		new_egg.entity_manager = entity_manager
		new_egg.type = 'snake'
		
		new_egg.global_position = parent.global_position
		entity_manager.add_child(new_egg)
	
