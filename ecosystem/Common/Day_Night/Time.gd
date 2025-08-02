extends CanvasLayer

@onready var canvas_modulate: CanvasModulate = $"../CanvasModulate"




func _ready():
	canvas_modulate.time_tick.connect(set_time)

func set_time(day: int, hour: int, minute: int):
	pass
