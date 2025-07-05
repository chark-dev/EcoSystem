extends Node2D
class_name MapGenerator

@export var tilemap : TileMapLayer
var cellScale = 4
#Isometric Coordinates
var cellSizeX : int = 32
var cellSizeY : int = 16

var mapWidth : int
var mapHeight : int
var gridWidth : int 
var gridHeight : int 

var map : Array 

func _ready():
	mapWidth = 10 * 360
	mapHeight = 10 * 180
	
	gridWidth = mapWidth / cellScale
	gridHeight = mapHeight / cellScale
	
