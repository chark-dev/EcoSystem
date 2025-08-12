extends Label


@export var day_label : Label

func _ready():
	Global.connect("time_tick", on_time_tick)
	Global.connect("day_passed", on_day_tick)


func on_time_tick(day: int, hour: int, minute: int):
	text = "Time:" + str(hour) + ":" + str(minute)

func on_day_tick(day: int):
	day_label.text = 'Day: ' + str(day)
