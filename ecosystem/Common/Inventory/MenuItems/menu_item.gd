extends ItemData
class_name MenuItem

enum TYPE {BEETLE, HERBIVORE, SNAKE, PAUSE}

@export var type : TYPE


func use() -> void:
	print(TYPE.keys()[type])
	
	match type:
		0:
			Global.emit_signal("beetle_highlight", 0)
		1:
			Global.emit_signal("herbi_highlight", 1)
		2:
			Global.emit_signal("snake_highlight", 2)
		3:
			Global.is_paused = !Global.is_paused
	pass
