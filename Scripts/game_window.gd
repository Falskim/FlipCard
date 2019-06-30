extends Node2D

var display_value = 0

onready var timer = get_node("timer")

func _ready():
	timer.set.wait_time(2)
	timer.start()

func game_time():
	pass # Replace with function body.
