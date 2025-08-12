extends Control  # or whatever your root node is

@onready var data_label = $VBoxContainer/Label
@onready var save_button = $VBoxContainer/save
@onready var main_menu_button = $VBoxContainer/exit
@onready var file_dialog = $FileDialog

const MAIN_MENU = preload("res://Stages/menu/main_menu.tscn")



func _ready():
	_display_data()

func _display_data():
	var text = ""
	for key in Global.ecosystem_data.keys():
		text += str(key) + ": " + str(Global.ecosystem_data[key]) + "\n"
	data_label.text = text






func _save_data_to_file():
	file_dialog.show()
	

	


func _on_save_pressed() -> void:
	_save_data_to_file()


func _on_exit_pressed() -> void:
	get_tree().change_scene_to_packed(MAIN_MENU)


func _on_file_dialog_file_selected(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.WRITE)
	
	var json_text = JSON.stringify(Global.ecosystem_data)
	file.store_string(json_text)
