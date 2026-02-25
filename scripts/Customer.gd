extends Resource
class_name Customer

@export var name: String
@export var mood: int = 50 # 0-100
@export var patience: float = 30.0 # seconds
@export var preferred_drink: String = "Espresso"

# Narrative hooks
var known_secrets: Array = []
var relationship_level: int = 0
var last_order_quality: float = 0.0

func _init(p_name = "Stranger", p_mood = 50, p_drink = "Espresso"):
	name = p_name
	mood = p_mood
	preferred_drink = p_drink

func evaluate_coffee(coffee_data: Dictionary) -> float:
	# Simple evaluation logic based on drink type
	var score = 0.0
	var liquid = coffee_data.get("liquid", 0.0)
	var grind = coffee_data.get("grind", 0.0)
	var milk_liquid = coffee_data.get("milk_liquid", 0.0)
	var froth = coffee_data.get("froth", 0.0)
	var milk_temp = coffee_data.get("milk_temp", 20.0)
	
	if liquid > 0 and grind > 0:
		score += 20 # Base score for actually making coffee
	
	match preferred_drink:
		"Espresso":
			# Espresso is just coffee (approx 30ml)
			if liquid > 25 and liquid < 40: score += 40
			else: score -= abs(30 - liquid)
			
			if milk_liquid < 10 and froth < 5: score += 20
			else: score -= 10 # Too much milk for espresso
			
		"Latte":
			# Latte is coffee + lots of steamed milk + little foam
			if liquid > 25: score += 10
			if milk_liquid > 100 and milk_liquid < 200: score += 40
			else: score -= abs(150 - milk_liquid) * 0.2
			
			if froth > 5 and froth < 30: score += 20 # Little foam
			
			if milk_temp > 55 and milk_temp < 70: score += 10
			
		"Cappuccino":
			# Cappuccino is coffee + equal parts milk + foam (approx)
			# Or usually 1/3 each.
			if liquid > 25: score += 10
			if milk_liquid > 30 and milk_liquid < 80: score += 30
			if froth > 30: score += 30
			
			if milk_temp > 55: score += 10
			
	last_order_quality = clamp(score, 0, 100)
	mood = clamp(mood + (last_order_quality - 50) / 5, 0, 100)
	return last_order_quality
