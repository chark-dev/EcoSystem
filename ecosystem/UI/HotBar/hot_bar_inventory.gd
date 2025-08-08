extends PanelContainer


const Slot = preload("res://UI/Slot/Slot.tscn")

@onready var item_grid: HBoxContainer = $MarginContainer/HBoxContainer
@export var inventory_interface : Control

func _ready():
	var inv_data = preload("res://Resources/TestInv.tres")
	populate_hotbar(inv_data)
	inventory_interface.set_player_inventory_data(inv_data)
	

#func set_inventory_data(inventory_data: InventoryData):
	#inventory_data.inventory_updated.connect(populate_item_grid)
	#populate_item_grid(inventory_data)

func populate_hotbar(inventory_data: InventoryData):
	for child in item_grid.get_children():
		child.queue_free()
	
	for slot_data in inventory_data.slot_datas.slice(0, 4):
		var slot = Slot.instantiate()
		item_grid.add_child(slot)
		
		slot.slot_clicked.connect(inventory_data.on_slot_clicked)
		
		if slot_data:
			slot.set_slot_data(slot_data)
