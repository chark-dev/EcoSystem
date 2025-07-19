extends Node2D
class_name Chest 

signal toggle_inventory(external_inventory_owner)

@export var inventory_data: InventoryData


@onready var outline_sprite_2d: Sprite2D = $OutlineSprite2D
signal new_hovered_entity(entity)

func _on_area_2d_mouse_entered() -> void:
	outline_sprite_2d.visible = true 
	new_hovered_entity.emit(self)


func _on_area_2d_mouse_exited() -> void:
	outline_sprite_2d.visible = false
	new_hovered_entity.emit(null)


func player_interact():
	toggle_inventory.emit(self)
