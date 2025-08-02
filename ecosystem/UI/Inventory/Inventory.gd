extends PanelContainer
class_name Inventory

const Slot = preload("res://UI/Slot/Slot.tscn")

@export var item_grid: GridContainer

func _ready():
	var inv_data = preload("res://Resources/TestInv.tres")
	populate_item_grid(inv_data)

func set_inventory_data(inventory_data: InventoryData):
	inventory_data.inventory_updated.connect(populate_item_grid)
	populate_item_grid(inventory_data)

func populate_item_grid(inventory_data: InventoryData):
	for child in item_grid.get_children():
		child.queue_free()
	
	for slot_data in inventory_data.slot_datas:
		var slot = Slot.instantiate()
		item_grid.add_child(slot)
		
		slot.slot_clicked.connect(inventory_data.on_slot_clicked)
		
		if slot_data:
			slot.set_slot_data(slot_data)
