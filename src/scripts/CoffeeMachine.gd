extends Area2D

# Preload the CoffeeCup scene
var coffee_scene = preload("res://src/scenes/CoffeeCup.tscn")
var spawn_offset: Vector2 = Vector2(0, 100)

func _ready():
	# Connect the input signal
	input_event.connect(_on_input_event)

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			spawn_cup()

func spawn_cup():
	if coffee_scene:
		var new_coffee = coffee_scene.instantiate()
		# Add to the parent scene (Main), not to the machine itself, so it doesn't move with the machine
		if get_parent():
			get_parent().add_child(new_coffee)
			new_coffee.global_position = global_position + spawn_offset
			print("Cup Spawned!")
	else:
		print("Error: Coffee scene failed to load.")
