extends Node
class_name State 

var parent : CharacterBody2D
var level_manager : LevelManager

func enter():
	pass

func exit():
	pass

func process_physics(delta: float) -> State:
	return null

func process_input(event: InputEvent) -> State:
	return null
