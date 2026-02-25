extends Area2D

signal customer_left

var max_patience: float = 15.0
var current_patience: float = 15.0
var tip_multiplier: float = 5.0 # Max tip
var order_value: int = 10

var recipes = [
	{ "name": "Cafe", "ingredients": ["Cafe"] },
	{ "name": "Leche", "ingredients": ["Leche"] },
	{ "name": "Latte", "ingredients": ["Cafe", "Leche"] }
]
var current_order = {}

@onready var patience_bar = $PatienceBar
@onready var timer = $Timer
@onready var label = $Label

func _ready():
	# Randomize patience slightly
	max_patience = randf_range(15.0, 25.0) # increased slightly as it takes more time now
	current_patience = max_patience

	# Pick a random order
	current_order = recipes.pick_random()
	current_order.ingredients.sort() # Ensure sorted

	# Setup timer
	timer.wait_time = max_patience
	timer.start()

	patience_bar.max_value = max_patience
	patience_bar.value = max_patience

	# Connect collision for receiving coffee
	area_entered.connect(_on_area_entered)
	timer.timeout.connect(_on_timeout)

	label.text = "Quiero:\n" + current_order.name

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
	# Verify ingredients
	coffee_cup.ingredients.sort()

	if coffee_cup.ingredients == current_order.ingredients:
		# Success
		var tip_ratio = current_patience / max_patience
		var tip = tip_multiplier * tip_ratio

		GameManager.add_score(order_value)
		if tip > 0:
			GameManager.add_tip(tip)
			GameManager.add_narrative("Cliente feliz! Propina: $" + str(snapped(tip, 0.01)))
		else:
			GameManager.add_narrative("Cliente satisfecho.")
	else:
		# Wrong order
		GameManager.add_narrative("Pedido incorrecto! Cliente enojado.")
		# No money? Or partial? Let's say no money for wrong order.

	coffee_cup.queue_free() # Remove the coffee
	leave()

func _on_timeout():
	GameManager.add_narrative("Cliente se fue esperando!")
	leave()

func leave():
	customer_left.emit()
	queue_free()
