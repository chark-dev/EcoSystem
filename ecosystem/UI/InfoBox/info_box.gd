extends Control


var is_open : bool = false

func _ready() -> void:
	Global.connect("beetle_highlight", open)


func open():
	if !is_open:
		self.show()
		is_open = !is_open
	else:
		self.hide()
		is_open = !is_open
