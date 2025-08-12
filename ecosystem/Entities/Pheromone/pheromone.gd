extends Node2D


var tile_pos : Vector2i
var source : CharacterBody2D
var lifetime = 25


func _process(delta):
	lifetime -= delta
	if lifetime <= 0:
		if source and source.level_manager:
			source.level_manager.tile_map.pheromone_map.erase(self)
			queue_free()
