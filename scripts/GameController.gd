extends Node2D

class_name GameController

@onready var machine = $CoffeeMachine
@onready var narrative = $NarrativeManager

# UI Nodes
@onready var status_label = $UI/VBoxContainer/StatusLabel
@onready var temp_label = $UI/VBoxContainer/TempLabel
@onready var customer_label = $UI/Panel/CustomerLabel
@onready var order_label = $UI/Panel/OrderLabel
@onready var feedback_label = $UI/Panel/FeedbackLabel

# Visual Cup Nodes
@onready var coffee_rect = $UI/CupVisual/CoffeeRect
@onready var milk_rect = $UI/CupVisual/MilkRect
@onready var foam_rect = $UI/CupVisual/FoamRect

func _ready():
	# Connect signals from UI buttons
	$UI/Controls/GrindButton.pressed.connect(_on_grind_pressed)
	$UI/Controls/BrewButton.pressed.connect(_on_brew_pressed)
	$UI/Controls/PourButton.pressed.connect(_on_pour_pressed)
	$UI/Controls/SteamButton.pressed.connect(_on_steam_pressed)
	$UI/Controls/ServeButton.pressed.connect(_on_serve_pressed)
	
	# Connect logic signals
	machine.machine_state_changed.connect(_on_machine_state_changed)
	narrative.new_customer.connect(_on_new_customer)
	narrative.customer_left.connect(_on_customer_left)
	narrative.day_ended.connect(_on_day_ended)
	
	# Start
	narrative.start_day()

func _process(delta):
	# Note: In a real project, accessing enums like this via the instance might be ambiguous without type hints, 
	# but for display purposes the int value is sufficient.
	status_label.text = "State: " + str(machine.current_state)
	temp_label.text = "Temp: %.1f C | Pressure: %.1f Bar" % [machine.temperature, machine.pressure]
	
	_update_cup_visual()

func _update_cup_visual():
	# Update heights based on liquid amount
	# Scale: 200px height represents approx 250ml
	var scale_factor = 0.8 
	
	var coffee_h = machine.extracted_liquid * scale_factor
	var milk_h = machine.milk_liquid * scale_factor
	var foam_h = machine.milk_froth * scale_factor
	
	# Stack: Coffee (bottom) -> Milk -> Foam (top)
	
	# Coffee
	coffee_rect.offset_bottom = 0
	coffee_rect.offset_top = -coffee_h
	
	# Milk
	milk_rect.offset_bottom = -coffee_h
	milk_rect.offset_top = -(coffee_h + milk_h)
	
	# Foam
	foam_rect.offset_bottom = -(coffee_h + milk_h)
	foam_rect.offset_top = -(coffee_h + milk_h + foam_h)

func _on_grind_pressed():
	print("Grind button pressed")
	machine.start_grinding(18.0)

func _on_brew_pressed():
	print("Brew button pressed")
	if machine.current_state == CoffeeMachine.State.BREWING:
		machine.stop_brewing()
	else:
		machine.start_brewing()

func _on_pour_pressed():
	print("Pour button pressed")
	if machine.current_state == CoffeeMachine.State.POURING:
		machine.stop_pouring()
	else:
		machine.start_pouring()

func _on_steam_pressed():
	print("Steam button pressed")
	if machine.current_state == CoffeeMachine.State.STEAMING:
		machine.stop_steaming()
	else:
		machine.start_steaming()

func _on_serve_pressed():
	print("Serve button pressed")
	var coffee = machine.serve_coffee()
	narrative.serve_order(coffee)

func _on_machine_state_changed(new_state):
	# Update UI based on state
	pass

func _on_new_customer(customer):
	customer_label.text = "Customer: " + customer.name
	order_label.text = "Order: " + customer.preferred_drink
	feedback_label.text = "Mood: %d" % customer.mood

func _on_customer_left(customer, reason):
	customer_label.text = "waiting..."
	order_label.text = ""
	feedback_label.text = "Last served: %s" % customer.name

func _on_day_ended(day, reputation):
	print("Day ended. Reputation: ", reputation)
	status_label.text = "Day %d Ended. Rep: %d" % [day, reputation]
