extends Control

@onready var message_container = $Background/ScrollContainer/VBoxContainer
@onready var background = $Background
@onready var toggle_button = $ToggleButton

var is_open = false

func _ready():
	# Connect to global signal
	GameManager.narrative_updated.connect(_on_narrative_updated)

	# Initial state
	is_open = false
	background.visible = false
	toggle_button.text = "Abrir Celular"

	# Connect button
	toggle_button.pressed.connect(_on_toggle_pressed)

	# Load initial messages
	_on_narrative_updated(GameManager.active_messages)

func _on_toggle_pressed():
	is_open = !is_open
	background.visible = is_open
	if is_open:
		toggle_button.text = "Cerrar Celular"
		GameManager.mark_messages_read()
	else:
		toggle_button.text = "Abrir Celular"

func _on_narrative_updated(messages):
	# Clear existing
	for child in message_container.get_children():
		child.queue_free()

	# Add new messages
	for msg in messages:
		var label = Label.new()
		label.text = "[" + msg["time"] + "] " + msg["text"]
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		# If unread, make it bold or different color (using rich text label would be better but simple label is safer for now)
		if not msg["read"]:
			label.modulate = Color(1, 1, 0) # Yellow for unread
		else:
			label.modulate = Color(1, 1, 1)

		message_container.add_child(label)
		# Add separator
		var separator = HSeparator.new()
		message_container.add_child(separator)
