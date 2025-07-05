extends Node2D
class_name CCDLimb

@export var root_pos: Vector2 
@export var num_joints: int = 4
@export var segment_length: float = 50.0

var joints: Array[Joint] = []
var target_pos: Vector2

func _ready():
	target_pos = root_pos + Vector2(150, 0)

	# Create joints
	for i in range(num_joints):
		var joint_pos = root_pos + Vector2(segment_length * i, 0)
		var j = Joint.new(joint_pos, segment_length, 0.0)
		add_child(j)
		joints.append(j)

func _physics_process(_delta: float) -> void:
	target_pos = to_local(get_global_mouse_position())
	update_ccd()
	update_positions()
	queue_redraw()

func update_ccd():
	var end_effector = joints.back()
	var tolerance = 1.0

	for _step in range(10):  # Iterative solver
		if (end_effector.position.distance_to(target_pos) < tolerance):
			break

		for i in range(joints.size() - 1, -1, -1):
			var joint = joints[i]
			end_effector = joints.back()
			joint.update_angle(end_effector.position, target_pos)
			update_positions()  # Forward kinematics pass after each rotation

func update_positions():
	joints[0].position = root_pos
	for i in range(1, joints.size()):
		var prev = joints[i - 1]
		var curr = joints[i]
		curr.position = prev.position + Vector2(cos(prev.angle), sin(prev.angle)) * prev.length

func _draw():
	for i in range(joints.size() - 1):
		draw_line(joints[i].position, joints[i + 1].position, Color.BLACK, 3.0)
	draw_circle(target_pos, 5, Color.RED)
