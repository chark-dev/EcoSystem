extends Node
class_name AntColony


@export var level_manager : LevelManager
@export var map_generator : MapGenerator
@export var ant_scene = preload("res://Entities/Ant/Ant.tscn")
@export var number_of_ants = 20

var ants = []
var food_nodes = []
var g_best = null
var food_counts = {}

var home_tile = Vector2.ZERO

func _ready():
	# Random home location
	home_tile = get_random_home_tile()
	food_nodes = map_generator.food_map

	for i in range(number_of_ants):
		var ant = ant_scene.instantiate()
		ant.colony = self
		ant.level_manager = level_manager
		add_child(ant)
		ants.append(ant)

func get_random_home_tile():
	return map_generator.map_to_local(Vector2i(randi() % map_generator.width, randi() % map_generator.height))

func register_food_collection(tile_pos: Vector2i):
	if not food_counts.has(tile_pos):
		food_counts[tile_pos] = 0
	food_counts[tile_pos] += 1

	if food_counts[tile_pos] >= 10:
		remove_food(tile_pos)

func remove_food(tile_pos: Vector2i):
	for i in food_nodes.size() - 1: # reverse loop
		if food_nodes[i]["tile"] == tile_pos:
			food_nodes[i]["node"].queue_free()
			food_nodes.remove_at(i)
			break
	# Reset g_best so ants start searching again
	g_best = null
