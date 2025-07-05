extends Marker2D
class_name Joint

var length : float 
var angle : float 
var width : float 

func _init(_position : Vector2, _length : float, _angle : float) -> void:
	position = _position
	length = _length
	angle = _angle
	
	
	
	
	var visual = Sprite2D.new()
	visual.texture = preload("res://joint.png")
	visual.centered = true  # Or any visual representation
	add_child(visual)
  # So it stays centered on the joint


func update_angle(end_effector_pos: Vector2, target_pos: Vector2) -> void:
	var to_effector = end_effector_pos - position
	var to_target = target_pos - position
	
	var current_angle = to_effector.angle()
	var desired_angle = to_target.angle()
	
	var delta = desired_angle - current_angle
	
	# Optional: clamp the rotation to stabilize
	var max_delta = deg_to_rad(20)
	delta = clamp(delta, -max_delta, max_delta)
	
	angle += delta


func _process(_delta):
	rotation = angle
