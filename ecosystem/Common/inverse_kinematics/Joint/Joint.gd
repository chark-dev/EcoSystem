extends Marker2D
class_name Joint

var length : float 
var min_angle : float = deg_to_rad(-45)
var max_angle : float = deg_to_rad(45)

func _init(_position : Vector2, _length : float) -> void:
	global_position = _position
	length = _length
	
	var visual = Sprite2D.new()
	visual.texture = preload("res://joint.png")  # Or any visual representation
	add_child(visual)
	visual.centered = true  # So it stays centered on the joint
	
	
	
