extends Node2D
class_name LevelManager 


var combat = false

@export var tile_map : TileMapLayer
var astar_grid : AStarGrid2D

@export var TBmanager : TurnBasedManager
@export var EManager : EntityManager


@export var player: Player 
@export var inventory_interface: Control 


var hovered_entity

func init():
	astar_grid = AStarGrid2D.new()
	astar_grid.region = tile_map.get_used_rect()
	
	astar_grid.cell_size = Vector2(32,16)
	
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()
	
	inventory_init()
	

func _ready():
	player.toggle_inventory.connect(toggle_inventory_interface)
	

func inventory_init():
	inventory_interface.set_player_inventory_data(player.inventory_data)
	
	for node in get_tree().get_nodes_in_group("external_inventory"):
		node.toggle_inventory.connect(toggle_inventory_interface)

func set_hovered_entity(entity):
	hovered_entity = entity
	print(hovered_entity)


func toggle_inventory_interface(external_inventory_owner = null):
	inventory_interface.visible = not inventory_interface.visible
	
	if external_inventory_owner:
		inventory_interface.set_external_inventory(external_inventory_owner)


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




func get_creatures():
	return EManager.get_entities()
