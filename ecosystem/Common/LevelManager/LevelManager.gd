extends Node2D
class_name LevelManager 


var combat = false

@export var tile_map : TileMapLayer
var astar_grid : AStarGrid2D

@export var TBmanager : TurnBasedManager
@export var EManager : EntityManager


@export var player: Player 
#@export var inventory_interface: Control 



var hovered_entity

func _ready():
	tile_map.init()
	astar_grid = AStarGrid2D.new()
	astar_grid.region = tile_map.get_used_rect()
	
	astar_grid.cell_size = Vector2(32,16)
	
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()

func get_actor_path(current_pos, target_pos):
	
	var id_path = astar_grid.get_id_path(
		tile_map.local_to_map(current_pos),
		tile_map.local_to_map(target_pos)
	)
	
	var current_point_path = astar_grid.get_point_path(
		tile_map.local_to_map(current_pos),
		tile_map.local_to_map(target_pos)
	)
	
	
	return id_path



func convert_path(target: Vector2i):
	return tile_map.map_to_local(target)

func draw_path():
	pass


func highlight_tiles(tiles):
	for tile in tiles:
		var polygon = Polygon2D.new()
		polygon.polygon = PackedVector2Array([
			Vector2(0, -8),
			Vector2(16, 0),
			Vector2(0, 8),
			Vector2(-16, 0)
		])
		polygon.color = Color(1, 1, 1, 0.2)
		polygon.visible = true
		polygon.position = tile_map.map_to_local(tile)
		add_child(polygon)


func get_heuristic_tiles(is_predator : bool, creature) -> Dictionary:
	var tile_dict = {}
	
	if not is_predator:
		var predator_tiles = get_predator_tiles()
		tile_dict["predator_tiles"] = predator_tiles
#	Get Player Tile 

#   Get Ally Tiles
	var ally_tiles = get_ally_tiles(creature)
	if ally_tiles:
		tile_dict["ally_tiles"] = ally_tiles
	
	print(tile_dict)
	
	return tile_dict

func get_ally_tiles(creature : CharacterBody2D):
	var output : Array[Vector2i]
	var creatures = get_tree().get_nodes_in_group("prey")
	if creatures:
		for c in creatures:
			if c.get_class() == creature.get_class():
				var tile_pos = tile_map.local_to_map(c.global_position)
				output.append(tile_pos)
		return output
	else:
		return []


func get_predator_tiles() -> Array[Vector2i]:
	var output : Array[Vector2i]
	var predators = get_tree().get_nodes_in_group("predator")
	if predators:
		for predator in predators:
			var tile_pos = tile_map.local_to_map(predator.global_position)
			output.append(tile_pos)
		return output
	else:
		return []

func get_creatures():
	return EManager.get_entities()
