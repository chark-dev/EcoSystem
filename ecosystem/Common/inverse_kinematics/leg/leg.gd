extends Node
class_name Limb

# Length of each limb segment 
var joints : Array

var numEffectors : int = 4
var target_pos : Vector2
@export var root_pos : Vector2



func _ready() -> void:
	
	print(root_pos)
	
	print("^ Root Pos for limb.")
	
	var ls : float = 10
	var sum : float = 0
	
	print("Printing positions for joints.")
	
	for i in range(numEffectors):
		var newEffector = Joint.new(Vector2(root_pos.x, root_pos.y - sum), ls)
		add_child(newEffector)
		print(newEffector.position)
		joints.append(newEffector)
		sum += 10
		ls*=0.8
	
	joints = get_children()
	
	#end_effector = joints[len(joints)-1]


# VISUAL REPRESENTATION

#func _draw() -> void:
	#
	## Draws a Circle on Each Joint 
	#var index = 0
	#for joint in joints:
		#draw_circle(joint.position, 2, Color.AQUA, true)
		#index += 1
		#if index >= len(joints):
			#return
	## Draws a Line between each joint
		#draw_line(joint.position, joints[index].position, Color.BLACK)
