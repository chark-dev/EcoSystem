extends ItemData
class_name MenuItem

enum TYPE {BEETLE, HERBIVORE, SNAKE}

@export var type : TYPE


func use() -> void:
	print(TYPE.keys()[type])
	
	match type:
		0:
			Global.emit_signal("beetle_highlight")
		1:
			Global.emit_signal("herbi_highlight")
		2:
			Global.emit_signal("snake_highlight")
	pass
