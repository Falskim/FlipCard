extends Node2D

# Grid Variables
export (int) var width
export (int) var height
export (int) var x_start
export (int) var y_start
export (int) var offset

# Cards Array
var back_card = preload("res://Scenes/Card's Scene/back_card.tscn")
var possible_cards = [
preload("res://Scenes/Card's Scene/black_card.tscn"),
preload("res://Scenes/Card's Scene/blue_card.tscn"),
preload("res://Scenes/Card's Scene/brown_card.tscn"),
preload("res://Scenes/Card's Scene/cream_card.tscn"),
preload("res://Scenes/Card's Scene/green_card.tscn"),
preload("res://Scenes/Card's Scene/grey_card.tscn"),
preload("res://Scenes/Card's Scene/orange_card.tscn"),
preload("res://Scenes/Card's Scene/pink_card.tscn"),
preload("res://Scenes/Card's Scene/purple_card.tscn"),
preload("res://Scenes/Card's Scene/red_card.tscn"),
preload("res://Scenes/Card's Scene/white_card.tscn"),
preload("res://Scenes/Card's Scene/yellow_card.tscn")
]

var all_cards = []
var back_cards = []

# Touch Variables
var mouse_position = Vector2(0, 0)
var first_touch = true
var first_card = back_card
var second_card = back_card
var pos_x_1 = 0
var pos_y_1 = 0
var pos_x_2 = 0
var pos_y_2 = 0
var check = false

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	all_cards = make_2d_array()
	back_cards = make_2d_array()
	spawn_back_cards()
	print(back_cards)
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
			back_cards[i][j] = back

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
		if (is_in_grid(x_pos, y_pos) && all_cards[x_pos][y_pos] != null):
			print(grid_position)
			touch_check(x_pos, y_pos)
		else:
			print("Not Found")

func touch_check(x, y):	
	if first_touch:
		back_cards[x][y].queue_free()
		first_card = all_cards[x][y]
		pos_x_1 = x
		pos_y_1 = y
		
		print("first card = " + first_card.color)
		first_touch = false
	else:
		back_cards[x][y].queue_free()
		second_card = all_cards[x][y]
		pos_x_2 = x
		pos_y_2 = y
		
		print("second card = " + second_card.color)
		first_touch = true
		check = true

	if check:
		if first_card != second_card:
			if first_card.color == second_card.color:
				first_card.queue_free()
				all_cards[pos_x_1][pos_y_2] = null
				second_card.queue_free()
				all_cards[pos_x_2][pos_y_2] = null
				check = false
			else:
				var back1 = back_card.instance()
				add_child(back1)
				back1.position = grid_to_pixel(pos_x_1, pos_y_1)
				
				var back2 = back_card.instance()
				add_child(back2)
				back2.position = grid_to_pixel(pos_x_2, pos_y_2)
				pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	touch_input()