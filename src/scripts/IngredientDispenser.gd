extends Area2D

@export var ingredient_name: String = "Cafe"
@export var fill_time: float = 1.0

var current_cup: Area2D = null
var timer: Timer

func _ready():
	# Setup timer
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = fill_time
	timer.one_shot = true
	timer.timeout.connect(_on_timeout)

	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

	$Label.text = ingredient_name

func _on_area_entered(area):
	if area.is_in_group("coffee"):
		current_cup = area
		timer.start()
		print("Filling cup with " + ingredient_name + "...")

func _on_area_exited(area):
	if area == current_cup:
		current_cup = null
		timer.stop()
		print("Cup removed.")

func _on_timeout():
	if current_cup:
		if current_cup.has_method("add_ingredient"):
			current_cup.add_ingredient(ingredient_name)
			print("Added " + ingredient_name + " to cup.")
		else:
			print("Error: Cup missing add_ingredient method.")
