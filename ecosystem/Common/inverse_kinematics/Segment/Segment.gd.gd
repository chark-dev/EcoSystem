extends Node2D
class_name Segment 


var angle : float
var distance : float
var radius : float 
var hue : Color 

func _init(_position, _angle, _distance, _radius, _hue):
	position = _position
	angle = _angle
	distance = _distance
	radius = _radius
	hue = _hue


func _physics_process(delta: float) -> void:
	rotation = angle
	
#	Update position?
	
	queue_redraw()

func update_position(previous : Segment):
	var a : float = atan2(previous.position.y - position.y, previous.position.x - position.x)
#	Gets angle in radians between two points 
	angle = a
	
	var d : float = sqrt(pow(previous.position.x-position.x,2) + pow(previous.position.y-position.y, 2))
	
	if d > distance:
		var delta : float = d - distance
		position.x += delta * cos(angle)
		position.y += delta * sin(angle)

func _draw():
	draw_circle(Vector2.ZERO, radius, hue)
#	Draw Line from center of circle to target. 
