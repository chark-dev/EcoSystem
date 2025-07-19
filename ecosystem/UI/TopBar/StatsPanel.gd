extends VBoxContainer

#func create_stat_bar(color : Color, max_value : int, label : String) -> ProgressBar:
	#var bar = ProgressBar.new()
	#bar.min_value = 0
	#bar.max_value = max_value
	#bar.value = max_value
	#bar.custom_minimum_size = Vector2(20, 16)
#
	## Set style for bar fill
	#var style = StyleBoxFlat.new()
	#style.bg_color = color
	#bar.add_theme_stylebox_override("fill", style)
#
	#bar.add_theme_font_size_override("font_size", 10)
	#bar.add_theme_color_override("font_color", Color.WHITE)
	##bar.text = label + ": " + str(bar.value) + "/" + str(bar.max_value)
	#return bar
#
#
#var hp_bar = create_stat_bar(Color.RED, 100, "HP")
#var energy_bar = create_stat_bar(Color.BLUE, 100, "Energy")
#var ap_bar = create_stat_bar(Color.ORANGE, 50, "AP")
#
#func _ready():
	#add_child(hp_bar)
	#add_child(energy_bar)
	#add_child(ap_bar)
