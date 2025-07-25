extends Node

var player : Player

#func _ready():
	#player.toggle_inventory.connect(toggle_inventory_interface)
	#
#
#func inventory_init():
	#inventory_interface.set_player_inventory_data(player.inventory_data)
	#
	#for node in get_tree().get_nodes_in_group("external_inventory"):
		#node.toggle_inventory.connect(toggle_inventory_interface)
#
#func set_hovered_entity(entity):
	#hovered_entity = entity
	#print(hovered_entity)
#
#
#func toggle_inventory_interface(external_inventory_owner = null):
	#inventory_interface.visible = not inventory_interface.visible
	#
	#if external_inventory_owner:
		#inventory_interface.set_external_inventory(external_inventory_owner)
