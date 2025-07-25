extends Node
class_name TurnBasedManager

@export var level_manager : LevelManager
var queue : Array
var completed = false
 
func _ready():
	SignalBus.turn_complete.connect(on_turn_complete)

func init_combat():
	randomize()
	queue.clear()

	for creature in level_manager.get_creatures():
		creature.stats.initiative += (randi() % 10 + 1)
		print(creature.stats.initiative)
		queue.append(creature)
	
	
	queue.sort_custom(func(a, b): return b.stats.initiative - a.stats.initiative)
	
	print("Queue: ", queue)
	
	start_combat()

 
var current_index := 0

func start_combat():
	current_index = 0
	await do_turn()

func do_turn():
	if queue.is_empty():
		print("No creatures in queue.")
		return

	var creature = queue[current_index]
	print(creature.name, " is taking a turn.")
	creature.take_turn()
	
	
	# INSTEAD HERE WE NEED TO AWAIT A SIGNAL FROM THE BEETLE
	print("Waiting for turn_complete signal...")
	await completed == true
	print("Received turn_complete signal!")
	
	
	
	await get_tree().create_timer(5.0).timeout
	
	
	completed = false
	# Advance to next creature
	current_index += 1
	if current_index >= queue.size():
		current_index = 0  # Loop back to start

	await do_turn()


func on_turn_complete():
	completed = true
