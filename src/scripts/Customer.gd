extends Area2D

signal customer_left

var max_patience: float = 15.0
var current_patience: float = 15.0
var tip_multiplier: float = 5.0 # Max tip
var order_value: int = 10

@onready var patience_bar = $PatienceBar
@onready var timer = $Timer
@onready var label = $Label

func _ready():
	# Randomize patience slightly
	max_patience = randf_range(10.0, 20.0)
	current_patience = max_patience

	# Setup timer
	timer.wait_time = max_patience
	timer.start()

	patience_bar.max_value = max_patience
	patience_bar.value = max_patience

	# Connect collision for receiving coffee
	area_entered.connect(_on_area_entered)
	timer.timeout.connect(_on_timeout)

	label.text = "Cliente"

func _process(delta):
	current_patience = timer.time_left
	patience_bar.value = current_patience

	# Change color based on patience
	if current_patience < 5.0:
		patience_bar.modulate = Color.RED
	else:
		patience_bar.modulate = Color.GREEN

func _on_area_entered(area):
	if area.is_in_group("coffee"):
		serve(area)

func serve(coffee_cup):
	# Calculate tip
	var tip_ratio = current_patience / max_patience
	var tip = tip_multiplier * tip_ratio

	GameManager.add_score(order_value)
	if tip > 0:
		GameManager.add_tip(tip)
		GameManager.add_narrative("Propina recibida: $" + str(snapped(tip, 0.01)))

	coffee_cup.queue_free() # Remove the coffee
	leave()

func _on_timeout():
	GameManager.add_narrative("Cliente se fue enojado!")
	leave()

func leave():
	customer_left.emit()
	queue_free()
