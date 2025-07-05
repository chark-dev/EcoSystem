extends Node
class_name Cell 

var altitude : float 
var fruitScent : float 
var seaweedScent : float 
var food : String 

func _init(a):
	altitude = a
	fruitScent = 0
	seaweedScent = 0
	food = ""
