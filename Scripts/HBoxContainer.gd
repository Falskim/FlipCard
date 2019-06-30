extends HBoxContainer

var display_value = 150

onready var timer = get_node("STimer")

# Called when the node enters the scene tree for the first time.
func _ready():
	#get_node("TimerLabel").text = str(display_value)
	
	#timer.set_wait_time(1)
	#timer.start()
	pass

func game_time():
	#display_value -= 1
	#get_node("TimerLabel").text = str(display_value)
	pass
