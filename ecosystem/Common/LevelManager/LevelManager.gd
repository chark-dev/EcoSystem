extends Node2D
class_name LevelManager 

@export var tile_map : TileMapLayer
var astar_grid : AStarGrid2D

func init():
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
