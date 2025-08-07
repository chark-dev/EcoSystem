extends Node2D
class_name Body 

var segments : Array[Segment]
# Length of the creature in segments
var length : int = 8
var root_pos : Vector2 
@export var target_pos : Vector2
@export var speed : int = 1

@onready var left_limb = $Limb
@onready var right_limb = $Limb2

func _init():
	segments = []
	root_pos = Vector2.ZERO
	var r1 : float = 5
	
	for i in range(length):
		var r : float = r1 - i * (r1/(length-1))
#		^ Controls the Shape of the creature's segments.


#		Makes Radius progressively get smaller. 
		var segment = Segment.new(Vector2(root_pos.x, root_pos.y * 0.5 - i * r1),
		0,
		r,
		r,
		Color.AQUAMARINE
		)
		segments.append(segment)
		add_child(segment)

func update_segments():
	var head : Segment = segments[0]
	
	var dir = (target_pos - head.position).normalized()
	head.angle = atan2(dir.y, dir.x)
	head.position += dir * speed
	
	
	var i = 1
	while i < length:
		var seg_c : Segment = segments[i]
		var seg_p : Segment = segments[i-1]
		
		seg_c.update_position(seg_p)
		
		i += 1
		
		
		
#func update_segments():
	#var head : Segment = segments[0]
#
	## Make the head follow the Snake node's position
	#head.position = to_local(get_parent().global_position)
#
	## Compute direction to target
	#var dir = (target_pos - head.position).normalized()
	#head.angle = lerp_angle(head.angle, atan2(dir.y, dir.x), 0.2)
#
	## Update trailing segments
	#for i in range(1, length):
		#var seg_c : Segment = segments[i]
		#var seg_p : Segment = segments[i - 1]
		#seg_c.update_position(seg_p)


func _physics_process(delta: float) -> void:
	update_segments()
	#left_limb.root_pos = segments[2].global_position  # Or an offset point like head.position
	#right_limb.root_pos = segments[3].global_position
	#queue_redraw()



#func _draw() -> void:
	#draw_foot(left_foot.position)
	#draw_foot(right_foot.position)


func draw_foot(foot: Vector2):
	draw_circle(foot, 3, Color.BROWN)
