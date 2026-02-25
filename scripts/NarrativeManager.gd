extends Node

class_name NarrativeManager

signal new_customer(customer)
signal customer_left(customer, reason)
signal day_ended(day_number, final_reputation)

var day: int = 1
var reputation: int = 50
var queue: Array = []
var current_customer: Customer = null

var customer_names = ["Alice", "Bob", "Charlie", "Diana", "Eve", "Frank", "Grace"]
var drinks = ["Espresso", "Latte", "Cappuccino"]

func _ready():
	randomize()

func start_day():
	print("Day ", day, " begins.")
	queue.clear()
	spawn_customers(5)
	next_customer()

func spawn_customers(amount):
	for i in range(amount):
		var c_name = customer_names[randi() % customer_names.size()]
		var c_drink = drinks[randi() % drinks.size()]
		# Create a new Customer instance (Resource)
		# Assuming Customer script is loaded as a class
		var c = load("res://scripts/Customer.gd").new()
		c.name = c_name
		c.preferred_drink = c_drink
		c.mood = randi_range(30, 80)
		queue.append(c)

func next_customer():
	if queue.is_empty():
		print("Day over.")
		emit_signal("day_ended", day, reputation)
		day += 1
		return
	
	current_customer = queue.pop_front()
	emit_signal("new_customer", current_customer)
	print("Customer arrived: ", current_customer.name, " wants ", current_customer.preferred_drink)

func serve_order(coffee_data):
	if current_customer == null: return
	
	var score = current_customer.evaluate_coffee(coffee_data)
	print("Customer rated coffee: ", score)
	reputation += (score - 50) * 0.1
	reputation = clamp(reputation, 0, 100)
	
	emit_signal("customer_left", current_customer, "served")
	current_customer = null
	
	# Delay before next customer
	# In a real game, this might wait for an animation
	await get_tree().create_timer(2.0).timeout
	next_customer()
