extends Node

static func clamp_value(value: float, minimum: float, maximum: float) -> float:
	return max(minimum, min(value, maximum))

static func distance_between(pos1: Vector2, pos2: Vector2) -> float:
	return pos1.distance_to(pos2)

static func is_position_in_range(pos: Vector2, target: Vector2, range_dist: float) -> bool:
	return distance_between(pos, target) <= range_dist

static func random_position_in_circle(center: Vector2, radius: float) -> Vector2:
	var angle = randf() * TAU
	var distance = randf() * radius
	return center + Vector2(cos(angle), sin(angle)) * distance

static func chance(probability: float) -> bool:
	return randf() < probability

static func format_number(number: int) -> String:
	if number >= 1000000:
		return "%.1fM" % (number / 1000000.0)
	elif number >= 1000:
		return "%.1fK" % (number / 1000.0)
	return str(number)

static func safe_divide(dividend: float, divisor: float, default_value: float = 0.0) -> float:
	if divisor == 0:
		return default_value
	return dividend / divisor