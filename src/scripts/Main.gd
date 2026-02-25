extends Node2D

@export var customer_scene: PackedScene
@onready var spawn_timer = $CustomerSpawner/Timer
@onready var spawn_point = $CustomerSpawner/SpawnPoint
@onready var score_label = $HUD/ScoreLabel
@onready var tips_label = $HUD/TipsLabel

func _ready():
	# Connect to GameManager signals
	GameManager.score_updated.connect(_on_score_updated)
	GameManager.tips_updated.connect(_on_tips_updated)

	# Initial HUD update
	_on_score_updated(GameManager.score)
	_on_tips_updated(GameManager.tips)

	# Start spawning customers
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()

func _on_score_updated(new_score):
	score_label.text = "Dinero: $" + str(new_score)

func _on_tips_updated(new_tips):
	tips_label.text = "Propinas: $" + str(snapped(new_tips, 0.01))

func _on_spawn_timer_timeout():
	spawn_customer()
	# Randomize next spawn time
	spawn_timer.wait_time = randf_range(5.0, 10.0)
	spawn_timer.start()

func spawn_customer():
	if customer_scene:
		var customer = customer_scene.instantiate()
		add_child(customer)
		customer.global_position = spawn_point.global_position

		# Connect to customer signals if needed
		# e.g., customer.customer_left.connect(_on_customer_left)

		print("Customer Spawned")
	else:
		print("Error: Customer scene not assigned.")
