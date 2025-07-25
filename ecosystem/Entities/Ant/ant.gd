extends CharacterBody2D
class_name Ant

var speed = 30
var target = null
var carrying_food = false

var p_best = null
var g_best = null
var home_tile = Vector2.ZERO

var food_found_count = 0

@export var level_manager: LevelManager
@export var colony : AntColony

func _ready():
	# Assign a random home if needed
	home_tile = colony.get_random_home_tile()
	position = home_tile

func _process(delta):
	if carrying_food:
		move_to(home_tile, delta)
		if global_position.distance_to(home_tile) < 10:
			carrying_food = false
	else:
		if target == null or is_food_consumed(target):
			target = colony.g_best if colony.g_best else find_random_target()
		move_to(target, delta)
		#check_for_food()
		

func move_to(target_pos: Vector2, delta):
	velocity = (target_pos - global_position).normalized() * speed
	global_position += velocity * delta

func find_random_target():
	return global_position + Vector2(randf_range(-100, 100), randf_range(-100, 100))

func is_food_consumed(target_pos):
	for food in colony.food_nodes:
		if food["tile"] == level_manager.tile_map.local_to_map(target_pos):
			return false
	return true

#func check_for_food():
	#for food in colony.food_nodes:
		#var food_pos = colony.level_manager.tile_map.map_to_local(food["tile"])
		#if global_position.distance_to(food_pos) < 10:
			#on_food_reached()
			#p_best = food["tile"]
			#if colony.g_best == null or global_position.distance_to(food_pos) < global_position.distance_to(colony.g_best):
				#colony.g_best = food["tile"]
			#break

func on_food_reached():
	carrying_food = true
	colony.register_food_collection(target)
