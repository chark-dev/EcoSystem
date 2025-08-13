extends Node2D


@export var hatch_timer : float = 7
var hatched : bool = false

var entity_manager : EntityManager
var level_manager : LevelManager
var type : String


func _physics_process(delta: float) -> void:
	if hatched:
		return
	
	
	
	hatch_timer -= delta 
	
	
	if hatch_timer <= 0:
		hatched = true
		hatch_egg()
	
	


func hatch_egg():
	Global.emit_signal("hatch_egg", global_position, type)
	
	queue_free()
