extends Node
class_name Evolver 


# Take in a set of data 
# Animal 
# Circumstances 


func evolve_animal(a: CharacterBody2D, b: CharacterBody2D) -> CreatureStats:
	var a_stats : CreatureStats = a.stats
	var b_stats : CreatureStats = b.stats
	
	
#	Randomly increment stats based on percentage
	process_mutation()
	
	
	process_color_changes()
	
	
#	Actually return new creature stats.
	return a_stats



func process_mutation():
	pass


func process_color_changes():
	pass
