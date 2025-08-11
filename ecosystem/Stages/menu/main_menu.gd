extends Control

@onready var name_input = $VBoxContainer/name_input
@onready var seed_input = $VBoxContainer/seed_input
@onready var time_input = $VBoxContainer/time_input
@onready var beetles_slider = $VBoxContainer/beetles_slider
@onready var rabbits_slider = $VBoxContainer/rabbits_slider
@onready var snakes_slider = $VBoxContainer/snakes_slider
@onready var start_button = $VBoxContainer/start_button

@onready var beetles_value_label = $"VBoxContainer/Beetles Count"
@onready var rabbits_value_label = $"VBoxContainer/Rabbits Count"
@onready var snakes_value_label = $"VBoxContainer/Snakes Count"
@onready var time_value_label = $"VBoxContainer/Starting Time"

func _ready():
	
	seed_input.text_changed.connect(_update_seed)
	beetles_slider.value_changed.connect(_update_beetles_label)
	rabbits_slider.value_changed.connect(_update_rabbits_label)
	snakes_slider.value_changed.connect(_update_snakes_label)
	time_input.value_changed.connect(_update_time_label)
	start_button.pressed.connect(_on_start_pressed)

func _update_seed(value):
	var caret_pos = seed_input.caret_column  # Save where the cursor is
	var regex := RegEx.new()
	regex.compile("[^0-9]")  # Remove anything not a digit
	var filtered_value := regex.sub(value.strip_edges(), "", true)
	seed_input.text = filtered_value
	seed_input.caret_column = min(caret_pos, seed_input.text.length())  # Restore position safely

func is_digit(char):
	return char >= "0" and char <= "9"

func _update_beetles_label(value):
	beetles_value_label.text = 'Num of Beetles: ' + str(value)

func _update_rabbits_label(value):
	rabbits_value_label.text = 'Num of Rabbits: ' + str(value)

func _update_snakes_label(value):
	snakes_value_label.text = 'Num of Snakes: ' + str(value)

func _update_time_label(value):
	time_value_label.text = 'Chosen Time: ' + str(value)

func _on_start_pressed():
	var data = {}
	data['ecosystem_name'] = name_input.text
	data['start_time'] = time_input.value
	data['beetles_count'] = beetles_slider.value
	data['rabbits_count'] = rabbits_slider.value
	data['snakes_count'] = snakes_slider.value
	data['seed'] = seed_input.text

	# You can now pass this data to your simulation
	Global.set_up_ecosystem(data)
