extends Label

@export var time : CanvasModulate

func _ready():
	time.connect("time_tick", on_time_tick)


func on_time_tick(day: int, hour: int, minute: int):
	text = "Time:\n" + str(hour) + "\n" + str(minute)
