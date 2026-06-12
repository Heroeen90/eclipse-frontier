extends Node

class_name AIController

var enemy: Enemy
var patrol_points: Array[Vector2] = []
var current_patrol_index: int = 0
var patrol_speed: float = 50.0

var _logger: Logger

func _ready():
	_logger = GameManager.instance.logger
	enemy = get_parent()

func add_patrol_point(point: Vector2):
	patrol_points.append(point)

func patrol():
	if patrol_points.is_empty():
		return
	
	var target_point = patrol_points[current_patrol_index]
	var direction = (target_point - enemy.global_position).normalized()
	enemy.velocity = direction * patrol_speed
	
	if enemy.global_position.distance_to(target_point) < 20:
		current_patrol_index = (current_patrol_index + 1) % patrol_points.size()

func chase(target_position: Vector2):
	var direction = (target_position - enemy.global_position).normalized()
	enemy.velocity = direction * enemy.speed

func attack():
	enemy.velocity = Vector2.ZERO
	if enemy.current_state == "attacking":
		enemy._attack()

func reset_state():
	enemy.current_state = "idle"
	enemy.target = null