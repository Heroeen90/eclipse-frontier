extends Node

class_name Utils

static func clamp_value(value: float, minimum: float, maximum: float) -> float:
	return max(minimum, min(value, maximum))

static func lerp_vector2(from: Vector2, to: Vector2, weight: float) -> Vector2:
	return from.lerp(to, weight)

static func distance_between(pos1: Vector2, pos2: Vector2) -> float:
	return pos1.distance_to(pos2)

static func is_position_in_range(pos: Vector2, target_pos: Vector2, range_distance: float) -> bool:
	return distance_between(pos, target_pos) <= range_distance

static func normalize_direction(direction: Vector2) -> Vector2:
	if direction == Vector2.ZERO:
		return Vector2.ZERO
	return direction.normalized()

static func get_angle_to_target(from: Vector2, to: Vector2) -> float:
	return (to - from).angle()

static func random_position_in_circle(center: Vector2, radius: float) -> Vector2:
	var angle = randf() * TAU
	var distance = randf() * radius
	return center + Vector2(cos(angle), sin(angle)) * distance

static func random_position_in_rect(rect: Rect2) -> Vector2:
	return Vector2(
		randf_range(rect.position.x, rect.position.x + rect.size.x),
		randf_range(rect.position.y, rect.position.y + rect.size.y)
	)

static func array_shuffle(array: Array) -> Array:
	var shuffled = array.duplicate()
	for i in range(shuffled.size() - 1, 0, -1):
		var j = randi() % (i + 1)
		var temp = shuffled[i]
		shuffled[i] = shuffled[j]
		shuffled[j] = temp
	return shuffled

static func chance(probability: float) -> bool:
	return randf() < probability

static func get_random_element(array: Array):
	if array.is_empty():
		return null
	return array[randi() % array.size()]

static func format_number(number: int) -> String:
	if number >= 1000000:
		return "%.2fM" % (number / 1000000.0)
	elif number >= 1000:
		return "%.2fK" % (number / 1000.0)
	else:
		return str(number)

static func format_time(seconds: float) -> String:
	var minutes = int(seconds) / 60
	var secs = int(seconds) % 60
	return "%02d:%02d" % [minutes, secs]

static func seconds_to_string(seconds: float) -> String:
	var hours = int(seconds) / 3600
	var minutes = (int(seconds) % 3600) / 60
	var secs = int(seconds) % 60
	
	if hours > 0:
		return "%dh %dm %ds" % [hours, minutes, secs]
	elif minutes > 0:
		return "%dm %ds" % [minutes, secs]
	else:
		return "%ds" % secs

static func validate_email(email: String) -> bool:
	var regex = RegEx.new()
	regex.compile("^[^@]+@[^@]+\\.[^@]+$")
	return regex.search(email) != null

static func validate_save_file(file_path: String) -> bool:
	if not FileAccess.file_exists(file_path):
		return false
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		return false
	
	var content = file.get_as_text()
	var json = JSON.new()
	return json.parse(content) == OK

static func safe_divide(dividend: float, divisor: float, default_value: float = 0.0) -> float:
	if divisor == 0:
		return default_value
	return dividend / divisor

static func exponential_cooldown(current_attempt: int, base_delay: float, max_delay: float) -> float:
	var delay = base_delay * pow(2.0, current_attempt)
	return min(delay, max_delay)

static func smoothstep(edge0: float, edge1: float, x: float) -> float:
	var t = clamp_value((x - edge0) / (edge1 - edge0), 0.0, 1.0)
	return t * t * (3.0 - 2.0 * t)