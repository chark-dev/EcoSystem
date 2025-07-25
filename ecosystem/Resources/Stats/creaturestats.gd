extends Resource
class_name CreatureStats

@export var health : int
@export var max_health : int
@export var movement : int 
@export var initiative : int
@export var courage : int
@export var hunger : int 

enum Gender { MALE, FEMALE }
@export var gender : Gender = Gender.MALE
