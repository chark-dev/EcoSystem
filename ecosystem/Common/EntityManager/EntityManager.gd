extends Node
class_name EntityManager

@onready var beetle_scene = preload("res://Entities/Beetle/Beetle.tscn")
@onready var rabbit_scene = preload("res://Entities/Rabbit/Rabbit.tscn")
@onready var snake_scene = preload("res://Entities/snake/snake.tscn")

@export var level_manager : LevelManager



var mammals : Array[Rabbit]

func set_up(data : Dictionary):
	
	for beetle in data['beetles_count']:
		var new_beetle = beetle_scene.instantiate()
		new_beetle.level_manager = level_manager
		new_beetle.entity_manager = self
		new_beetle.global_position = level_manager.tile_map.get_random_tile()
		add_child(new_beetle)

	
	for rabbit in data['rabbits_count']:
		var new_rabbit = rabbit_scene.instantiate()
		new_rabbit.level_manager = level_manager
		new_rabbit.entity_manager = self
		new_rabbit.global_position = level_manager.tile_map.get_random_tile()
		add_child(new_rabbit)
	
	for snake in data['snakes_count']:
		var new_snake = snake_scene.instantiate()
		new_snake.level_manager = level_manager
		new_snake.entity_manager = self
		new_snake.global_position = level_manager.tile_map.get_random_tile()
		add_child(new_snake)
		
	


func _ready() -> void:
	Global.connect("hatch_egg", hatch_egg)

func spawn_entities(data : Dictionary):
	pass

func get_entities():
	return get_children()

func add_to_mammals(body):
	mammals.append(body)

func hatch_egg(position, type):
	var new_entity : CharacterBody2D
	match type:
		'beetle':
			new_entity = beetle_scene.instantiate()
			Global.output_data['beetles_born'] += 1
		'rabbit':
			new_entity = rabbit_scene.instantiate()
			Global.output_data['rabbits_born'] += 1
		'snake':
			new_entity = snake_scene.instantiate()
			Global.output_data['snakes_born'] += 1
	new_entity.entity_manager = self
	new_entity.level_manager = level_manager
	
	new_entity.global_position = position
	
	add_child(new_entity)



func get_beetle_count():
	var count = 0
	for child in get_children():
		if child is Beetle:
			count += 1
	
	return str(count)

func get_beetle_mating():
	var male = 0
	var female = 0
	
	for child in get_children():
		if child is Beetle:
			if child.stats.gender == true:
				male += 1
			else:
				female += 1
	
	if male == 0 or female == 0:
		return str(0)
	
	return str(male / female)

func get_herbi_count():
	var count = 0
	for child in get_children():
		if child is Rabbit:
			count += 1
	
	return str(count)

func get_herbi_mating():
	var male = 0
	var female = 0
	
	for child in get_children():
		if child is Rabbit:
			if child.stats.gender == true:
				male += 1
			else:
				female += 1
	
	if male == 0 or female == 0:
		return str(0)
	
	return str(male / female)
	

func get_snake_count():
	print('Counting Snakes')
	var count = 0
	for child in get_children():
		if child is Snake:
			count += 1
	
	return str(count)

func get_snake_mating():
	var male = 0
	var female = 0
	
	for child in get_children():
		if child is Snake:
			if child.stats.gender == true:
				male += 1
			else:
				female += 1
	
	if male == 0 or female == 0:
		return str(0)
	
	return str("Males: " + str(male) + " Females: " + str(female))
