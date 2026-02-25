extends Node

class_name CoffeeMachine

signal coffee_ready(coffee_data)
signal machine_state_changed(new_state)

enum State { IDLE, GRINDING, HEATING, BREWING, STEAMING, POURING }

var current_state: State = State.IDLE

# Machine parameters
var water_level: float = 100.0
var bean_level: float = 100.0
var temperature: float = 20.0 # Celsius
var pressure: float = 0.0 # Bars

# Current cup properties
var grind_amount: float = 0.0
var extracted_liquid: float = 0.0 # Coffee liquid (ml)
var milk_liquid: float = 0.0 # Added milk liquid (ml)
var milk_froth: float = 0.0 # Milk froth/foam (ml equivalent)
var milk_temp: float = 20.0

# Constants
const MAX_TEMP = 95.0
const OPTIMAL_TEMP = 92.0
const MAX_PRESSURE = 9.0

func _process(delta):
	match current_state:
		State.HEATING:
			temperature += delta * 10.0
			if temperature >= MAX_TEMP:
				temperature = MAX_TEMP
				current_state = State.IDLE
				emit_signal("machine_state_changed", State.IDLE)
		State.BREWING:
			pressure = move_toward(pressure, MAX_PRESSURE, delta * 2.0)
			extracted_liquid += delta * 10.0 # ml per second
		State.POURING:
			milk_liquid += delta * 15.0 # ml per second
		State.STEAMING:
			milk_temp += delta * 5.0
			milk_froth += delta * 2.0
			# Steaming also heats the milk added
			if milk_liquid > 0:
				milk_temp += delta * 5.0 # Heat faster if we have liquid? Or simplified.

func start_grinding(amount: float):
	if current_state != State.IDLE: return
	current_state = State.GRINDING
	emit_signal("machine_state_changed", State.GRINDING)
	# Simulate grinding time
	await get_tree().create_timer(amount * 0.1).timeout
	grind_amount = amount
	bean_level -= amount
	current_state = State.IDLE
	emit_signal("machine_state_changed", State.IDLE)
	print("Grinding complete: ", grind_amount, "g")

func start_brewing():
	if current_state != State.IDLE: return
	if grind_amount <= 0:
		print("No coffee grounds!")
		return
	current_state = State.BREWING
	emit_signal("machine_state_changed", State.BREWING)

func stop_brewing():
	if current_state != State.BREWING: return
	current_state = State.IDLE
	emit_signal("machine_state_changed", State.IDLE)
	pressure = 0.0
	print("Brewing stopped. Extracted: ", extracted_liquid, "ml")

func start_pouring():
	if current_state != State.IDLE: return
	current_state = State.POURING
	emit_signal("machine_state_changed", State.POURING)

func stop_pouring():
	if current_state != State.POURING: return
	current_state = State.IDLE
	emit_signal("machine_state_changed", State.IDLE)
	print("Pouring stopped. Added Milk: ", milk_liquid, "ml")

func start_steaming():
	if current_state != State.IDLE: return
	current_state = State.STEAMING
	emit_signal("machine_state_changed", State.STEAMING)

func stop_steaming():
	if current_state != State.STEAMING: return
	current_state = State.IDLE
	emit_signal("machine_state_changed", State.IDLE)
	print("Steaming stopped. Milk Temp: ", milk_temp, " Froth: ", milk_froth)

func serve_coffee():
	var coffee_data = {
		"grind": grind_amount,
		"liquid": extracted_liquid,
		"milk_liquid": milk_liquid,
		"milk_temp": milk_temp,
		"froth": milk_froth,
		"water_temp": temperature
	}
	# Reset for next cup
	grind_amount = 0.0
	extracted_liquid = 0.0
	milk_liquid = 0.0
	milk_froth = 0.0
	milk_temp = 20.0
	
	emit_signal("coffee_ready", coffee_data)
	return coffee_data
