extends Node2D

export (String) var color;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func touch_input():
	if Input.is_action_just_pressed("ui_touch"):
		print("clicked")
		print(self.color)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass