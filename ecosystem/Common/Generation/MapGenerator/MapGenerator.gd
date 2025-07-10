extends TileMapLayer
class_name MapGenerator

@onready var target_origin = get_parent().get_child(2)
var moisture = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var altitude = FastNoiseLite.new()

@export var width = 32
@export var height = 32

@onready var food_scene = preload("res://Entities/Food/Food.tscn")
@onready var smell_scene = preload("res://Entities/Smell/Smell.tscn")


func _ready() -> void:
	moisture.seed = randi()
	temperature.seed = randi()
	altitude.seed = randi()
	generate_chunk(target_origin.position)
	queue_redraw()
	print(get_used_rect())
	get_parent().init()



func _process(delta: float) -> void:
	queue_redraw()


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
			
			if alt < 1:
				set_cell(Vector2i(tile_pos.x - width/2 + x, tile_pos.y - height/2 + y), 0, Vector2(0,0))
			else:
				set_cell(Vector2i(tile_pos.x - width/2 + x, tile_pos.y - height/2 + y), 0, Vector2(round(moist+10)/5,0))
				spawn_food(Vector2i(tile_pos.x - width/2 + x, tile_pos.y - height/2 + y))


func spawn_food(tile_pos : Vector2i):
	if randf() < 0.01:
		var food = food_scene.instantiate()
		food.position = map_to_local(tile_pos)
		add_child(food)
		add_smell(tile_pos)

func add_smell(center: Vector2i):
	var offsets = [  # center
	Vector2i( 1,  1),  # top-right
	Vector2i(-1,  1),  # top-left
	Vector2i( 1, -1),  # bottom-right
	Vector2i(-1, -1),  # bottom-left
	Vector2i(-1,  0),  # left
	Vector2i( 0, -1),  # down
	Vector2i( 0,  1),  # up
	Vector2i( 1,  0),  # right
	]
	
	for offset in offsets:
		var pos = center + offset
		var smell = smell_scene.instantiate()
		smell.position = map_to_local(pos)
		add_child(smell)
	
