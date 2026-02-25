extends Area2D

var dragging = false
var offset = Vector2.zero
var original_position = Vector2.zero

func _ready():
	original_position = global_position
	# Ensure the collision shape is setup correctly in the scene
	add_to_group("coffee")
	input_event.connect(_on_input_event)

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				offset = global_position - get_global_mouse_position()
			else:
				dragging = false
				# Optional: Snap back if not served? or stay?
				# For now, let it stay where dropped.

func _process(_delta):
	if dragging:
		global_position = get_global_mouse_position() + offset

func serve():
	queue_free()
