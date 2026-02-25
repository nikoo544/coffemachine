extends Node

# Global Game State
var score: int = 0
var tips: float = 0.0
var current_day: int = 1

# Narrative State
var narrative_log: Array = []
var active_messages: Array = [] # Messages currently visible on phone

# Signals to update UI
signal score_updated(new_score)
signal tips_updated(new_tips)
signal narrative_updated(messages)

func _ready():
	# Initial narrative hook
	add_narrative("Bienvenido a tu nueva cafeteria! Toca la maquina para hacer cafe.")

func add_score(amount: int):
	score += amount
	score_updated.emit(score)

func add_tip(amount: float):
	tips += amount
	tips_updated.emit(tips)

func add_narrative(message: String):
	var timestamp = Time.get_time_string_from_system()
	var entry = {
		"text": message,
		"time": timestamp,
		"read": false
	}
	narrative_log.append(entry)
	active_messages.append(entry)
	narrative_updated.emit(active_messages)

func mark_messages_read():
	for msg in active_messages:
		msg["read"] = true
	narrative_updated.emit(active_messages)
