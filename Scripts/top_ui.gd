extends TextureRect

onready var timer_label = $MarginContainer/HBoxContainer/TimerLabel
onready var star_label = $MarginContainer/HBoxContainer/StarLabel
onready var timer = get_node("Timer")

var current_star = 3
var display_time = 0

export (int) var three_star
export (int) var two_star
export (int) var one_star

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.set_wait_time(1)
	timer.start()
	
	star_label.text = String(current_star)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_star()

func game_timeout():
	display_time += 1
	timer_label.text = String(display_time)

func update_star():
	if display_time == three_star + 1:
		current_star = 2
	elif display_time == two_star + 1:
		current_star = 1
	elif display_time == one_star + 1:
		current_star = 0
	
	star_label.text = String(current_star)