extends TileMapLayer
class_name MapGenerator

@onready var target_origin = Vector2.ZERO
var moisture = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var altitude = FastNoiseLite.new()

@export var width = 64
@export var height = 64

@onready var food_scene = preload("res://Entities/Food/Food.tscn")
@onready var smell_scene = preload("res://Entities/Smell/Smell.tscn")
@onready var hide_scene = preload("res://Entities/HidingPlace/hide.tscn")
@onready var pheromone_scene = preload("res://Entities/Pheromone/Pheromone.tscn")

var smell_map = []
var mammal_smell_map = []
var food_map = []
var hide_map = []

var food_spawn_positions = []


var pheromone_map = []

var land_tiles = {}



func init() -> void:
	moisture.seed = randi()
	temperature.seed = randi()
	altitude.seed = randi()
	generate_chunk(target_origin)
	queue_redraw()

func _ready() -> void:
	Global.connect("hour_passed", spawn_food_hour)





func generate_chunk(target_origin):
	var tile_pos = local_to_map(target_origin)
	for x in range(width):
		for y in range(height):
			var moist = moisture.get_noise_2d(tile_pos.x - width/2 + x, tile_pos.y - height/2 + y)*10
			var temp = temperature.get_noise_2d(tile_pos.x - width/2 + x, tile_pos.y - height/2 + y)*10
			var alt = altitude.get_noise_2d(tile_pos.x - width/2 + x, tile_pos.y - height/2 + y)*10
			
			#set_cell(Vector2i(tile_pos.x - width/2 + x, tile_pos.y - height/2 + y), 0, Vector2i(1,0))
			
			
#			USING THE NOISE VALUES TO GET TILES
#			SETTING UP TILESET IN A 2D GRAPH CORRESPONDING TO THESE VALUES GIVES US 
			set_cell(Vector2i(tile_pos.x - width/2 + x, tile_pos.y - height/2 + y), 0, Vector2(round(moist+10)/5,0))
			
			if alt < 0.1:
				set_cell(Vector2i(tile_pos.x - width/2 + x, tile_pos.y - height/2 + y), 0, Vector2(0,0))
			else:
				set_cell(Vector2i(tile_pos.x - width/2 + x, tile_pos.y - height/2 + y), 0, Vector2(round(moist+10)/5,0))
				spawn_food(Vector2i(tile_pos.x - width/2 + x, tile_pos.y - height/2 + y))
				spawn_hide_place(Vector2i(tile_pos.x - width/2 + x, tile_pos.y - height/2 + y))


func spawn_hide_place(tile_pos: Vector2i):
	if randf() < 0.05:
		Global.output_data['hide_places'] += 1
		var hide_spot = hide_scene.instantiate()
		hide_spot.position = map_to_local(tile_pos)
		hide_spot.hide_source_tile = tile_pos
		add_child(hide_spot)
		hide_map.append(hide_spot)

func spawn_food(tile_pos: Vector2i):
	if randf() < 0.05:
		food_spawn_positions.append(tile_pos)
		Global.output_data['food_dropped'] += 1
		var food = food_scene.instantiate()
		food.position = map_to_local(tile_pos)
		add_child(food)
		add_smell(tile_pos)

		# Store a dictionary with position and reference to node
		food_map.append({
			"tile": tile_pos,
			"node": food
		})
		
		

func spawn_food_hour(hour: int):
	for i in range(2):
		print('Dropping 2 food')
		Global.output_data['food_dropped'] += 1
		var food = food_scene.instantiate()
		food.position = map_to_local(food_spawn_positions[randi() % food_spawn_positions.size()])
		add_child(food)
		add_smell(local_to_map(food.position))
		
		food_map.append({
		"tile": local_to_map(food.position),
		"node": food
		})
	
	

func add_smell(center: Vector2i):
	var offsets = [
		Vector2i( 0,  0),  # include center tile
		Vector2i( 1,  1), Vector2i(-1,  1),
		Vector2i( 1, -1), Vector2i(-1, -1),
		Vector2i(-1,  0), Vector2i( 0, -1),
		Vector2i( 0,  1), Vector2i( 1,  0),
	]
	
	for offset in offsets:
		var pos = center + offset
		var smell = smell_scene.instantiate()
		smell.position = map_to_local(pos)
		smell.food_source_tile = center  # new property to track source
		add_child(smell)
		smell_map.append(smell)


func drop_pheromone(tile_pos: Vector2i, source):
	var pheromone = pheromone_scene.instantiate()
	pheromone.position = map_to_local(tile_pos)
	pheromone.tile_pos = tile_pos
	pheromone.source = source  # optional: track who dropped it
	add_child(pheromone)
	pheromone_map.append(pheromone)
	
	print("The pheromone map size is: ", pheromone_map.size())



func get_random_tile() -> Vector2:
	var tile_pos = local_to_map(target_origin)
	var rand_x = tile_pos.x - width / 2 + randi() % width
	var rand_y = tile_pos.y - height / 2 + randi() % height
	return map_to_local(Vector2i(rand_x, rand_y))
