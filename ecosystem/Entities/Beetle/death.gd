extends State 
class_name Death 


# Make sprite upside down + start decay timer 
# Add as food on smell map to predators + bottom feeders. 
# after timer runs out, 

func process_physics(delta):
	pass



func enter():
	parent.label.text = "Death"
	
	if parent is Beetle:
		Global.output_data['dead_beetles'] += 1
	
	if parent is Rabbit:
		Global.output_data['dead_rabbits'] += 1
	
	if parent is Snake:
		Global.output_data['dead_snakes'] += 1
	
	die()


func die():
	await get_tree().create_timer(3).timeout
	
	parent.queue_free()
