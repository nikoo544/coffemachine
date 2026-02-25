extends Area2D

var dragging = false
var offset = Vector2.zero
var original_position = Vector2.zero
var ingredients: Array = []

@onready var liquid = $Liquid
@onready var label = $Label

func _ready():
	original_position = global_position
	# Ensure the collision shape is setup correctly in the scene
	add_to_group("coffee")
	input_event.connect(_on_input_event)

	# Initialize visual state
	update_visuals()

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				offset = global_position - get_global_mouse_position()
			else:
				dragging = false

func _process(_delta):
	if dragging:
		global_position = get_global_mouse_position() + offset

func add_ingredient(type: String):
	if ingredients.has(type):
		return # Already has this ingredient (prevent double adding for simplicity)

	ingredients.append(type)
	ingredients.sort() # Ensure consistent order for comparison (e.g. ["Cafe", "Leche"])
	update_visuals()

func update_visuals():
	if not liquid:
		return

	if ingredients.is_empty():
		liquid.visible = false
		label.text = "Vacio"
	else:
		liquid.visible = true
		liquid.scale.y = float(ingredients.size()) / 2.0 # Grow with ingredients (assuming max 2)

		# Determine color based on mix
		if ingredients == ["Cafe"]:
			liquid.color = Color(0.4, 0.2, 0.1) # Dark Brown
			label.text = "Cafe"
		elif ingredients == ["Leche"]:
			liquid.color = Color(0.9, 0.9, 0.8) # Off-white
			label.text = "Leche"
		elif ingredients == ["Cafe", "Leche"]:
			liquid.color = Color(0.7, 0.5, 0.3) # Light Brown
			label.text = "Latte"
		else:
			liquid.color = Color(0.5, 0.5, 0.5) # Mystery mix
			label.text = "Mezcla"

func get_recipe_name() -> String:
	if ingredients == ["Cafe"]:
		return "Cafe"
	elif ingredients == ["Cafe", "Leche"]:
		return "Latte"
	elif ingredients == ["Leche"]:
		return "Leche"
	else:
		return "Desconocido"

func serve():
	queue_free()
