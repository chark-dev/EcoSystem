extends Node2D
class_name IsometricCharacterController




func move_character(delta, speed : int):
	var input_vector = Vector2.ZERO
	# Traditional WASD or arrow input
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	# Normalize to prevent faster diagonal movement
	input_vector = input_vector.normalized()
	
	# Convert to isometric direction
	var iso_direction = Vector2(
		input_vector.x - input_vector.y,
		(input_vector.x + input_vector.y) / 2
	)
	
	return iso_direction * speed
