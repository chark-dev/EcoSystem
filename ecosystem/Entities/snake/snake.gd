extends Node2D
class_name Snake

@onready var points = $Points




func _draw():
	var joints = points.get_children()
	
	for joint in joints:
		draw_circle(joint.position, 1, Color.AQUA, true)
# Chain that goes through the middle of the body 
# Circles/Shapes that make up the Body 
# Shaders that change the colour based on the direction of travel.


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:  # Left mouse button was clicked
			print("Left mouse button clicked!")
