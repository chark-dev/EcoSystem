extends Node2D
class_name Limb

# Length of each limb segment 
var joints : Array[Joint]
var numEffectors : int = 8

var target_pos : Vector2
@export var root_pos : Vector2



func _ready() -> void:
	
	print(root_pos)
	
	print("^ Root Pos for limb.")
	
	var ls : float = 10
	var sum : float = 10
	
	print("Printing positions for joints.")
	
	var shoulder = Joint.new(Vector2(root_pos.x, root_pos.y), ls)
	add_child(shoulder)
	joints.append(shoulder)
	
	for i in range(numEffectors - 1):
		var newEffector = Joint.new(Vector2(root_pos.x, root_pos.y - sum), ls)
		add_child(newEffector)
		print(newEffector.position)
		joints.append(newEffector)
		sum += 10
		ls*=0.8
		#draw_line(newEffector.position, joints[i].position, Color.BLACK)


func _physics_process(delta: float) -> void:
	target_pos = to_local(get_global_mouse_position())
	fabrikF()
	fabrikB()


func fabrikF():
	var next : Joint = joints[len(joints) - 1]
	next.position = target_pos
	
	var i : int = len(joints) - 2
	while i >= 0:
		var current : Joint = joints[i]
		var direction : Vector2 = next.position - current.position
#		May have to normalise the vector here ^
		direction = direction.normalized() * current.length
		current.position = next.position - direction
		
		next = current
		
		i -= 1


func fabrikB():
	var previous : Joint = joints[0]
	previous.position = root_pos
	
	for i in range(len(joints)):
		var current : Joint = joints[i]
		var direction = current.position - previous.position
		
		direction = direction.normalized() * previous.length
		
		current.position = previous.position + direction
		# Reference direction: default is down
		
		# Apply angle constraint
		previous = current
