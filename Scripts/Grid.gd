extends Node2D

# Grid Variables
export (int) var width
export (int) var height
export (int) var x_start
export (int) var y_start
export (int) var offset
export (int) var card_size

# Cards Array
var back_card = preload("res://Scenes/back_card.tscn")
var possible_cards = [
preload("res://Scenes/black_card.tscn"),
preload("res://Scenes/blue_card.tscn"),
preload("res://Scenes/brown_card.tscn"),
preload("res://Scenes/cream_card.tscn"),
preload("res://Scenes/green_card.tscn"),
preload("res://Scenes/grey_card.tscn"),
preload("res://Scenes/orange_card.tscn"),
preload("res://Scenes/pink_card.tscn"),
preload("res://Scenes/purple_card.tscn"),
preload("res://Scenes/red_card.tscn"),
preload("res://Scenes/white_card.tscn"),
preload("res://Scenes/yellow_card.tscn")
]

var all_cards = []

# Touch Variables
var mouse_position = Vector2(0, 0)
var first_touch = true
var first_card = back_card
var second_card = back_card
var check = false

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	all_cards = make_2d_array()
	spawn_back_cards();
	spawn_cards()
	print(all_cards)

func make_2d_array():
	var array = []
	for i in width:
		array.append([])
		for j in height:
			array[i].append(null)
	return array

func spawn_cards():
	for i in width:
		for j in height:
			#Choose a randowm number and store it
			var rand = floor(rand_range(0, possible_cards.size()))
			var card = possible_cards[rand].instance()

			var loops = 0
			while(same_card(card.color) && loops < 100):
				rand = floor(rand_range(0, possible_cards.size()))
				loops += 1
				card = possible_cards[rand].instance()

			#Intance color cards from the array
			add_child(card)
			card.position = grid_to_pixel(i, j)
			all_cards[i][j] = card

func spawn_back_cards():
	for i in width:
		for j in height:
			#Intance back card from the array
			var back = back_card.instance()
			add_child(back)
			back.position = grid_to_pixel(i, j)
			all_cards[i][j] = back

func same_card(color):
	var same = 0
	for i in width:
		for j in height:
			if all_cards[i][j].color == color:
				same += 1
	
	if(same == 2):
		return true
	pass

func grid_to_pixel(column, row):
	var new_x = x_start + offset * column
	var new_y = y_start + -offset * row
	return Vector2(new_x, new_y)

func pixel_to_grid(pixel_x, pixel_y):
	var new_x = round((pixel_x - x_start) / offset)
	var new_y = round((pixel_y - y_start) / -offset)
	return Vector2(new_x, new_y)

func is_in_grid(column, row):
	if column >= 0 && column < width:
		if row >= 0 && row < height:
			return true
	return false

func touch_input():
	if Input.is_action_just_pressed("ui_touch"):
		mouse_position = get_global_mouse_position()
		var grid_position = pixel_to_grid(mouse_position.x, mouse_position.y)
		var x_pos = grid_position.x
		var y_pos = grid_position.y
		if is_in_grid(x_pos, y_pos):
			print(grid_position)
			touch_check(x_pos, y_pos)
		else:
			print("Not Found")

func touch_check(x, y):
	if first_touch:
		first_card = all_cards[x][y]
		print("first card = " + first_card.color)
		first_touch = false
	else:
		second_card = all_cards[x][y]
		print("second card = " + second_card.color)
		first_touch = true
		check = true

	if check:
		if first_card.color == second_card.color:
			first_card.queue_free()
			second_card.queue_free()
			check = false

func destroy_matched():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	touch_input()


func _on_destroy_timer_timeout():
	pass # Replace with function body.
