extends Camera2D




@export var zoom_step: float = 0.1
@export var min_zoom: float = 0.2
@export var max_zoom: float = 3.0

var dragging := false
var drag_origin := Vector2.ZERO

func _unhandled_input(event):
	# Start dragging
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				drag_origin = get_viewport().get_mouse_position()
			else:
				dragging = false

		# Scroll wheel zoom
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_adjust_zoom(-zoom_step)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_adjust_zoom(zoom_step)

	# Continue dragging
	elif event is InputEventMouseMotion and dragging:
		var mouse_delta = event.position - drag_origin
		global_position -= mouse_delta * zoom
		drag_origin = event.position

func _adjust_zoom(amount):
	var new_zoom = zoom + Vector2.ONE * amount
	new_zoom.x = clamp(new_zoom.x, min_zoom, max_zoom)
	new_zoom.y = clamp(new_zoom.y, min_zoom, max_zoom)
	zoom = new_zoom
