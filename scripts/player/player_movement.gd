extends Node2D

class_name PlayerMovement

var player_controller: PlayerController
var target_position: Vector2
var is_moving_to_target = false
var move_speed = 200

var _logger: Logger

func _ready():
	player_controller = get_parent()
	_logger = GameManager.instance.logger

func move_to_position(target: Vector2, speed: float = 200) -> void:
	target_position = target
	is_moving_to_target = true
	move_speed = speed
	_logger.debug("Moving to position: %s" % target, "PlayerMovement")

func _physics_process(delta):
	if not is_moving_to_target:
		return
	
	var direction = (target_position - player_controller.global_position).normalized()
	
	if player_controller.global_position.distance_to(target_position) < 10:
		is_moving_to_target = false
		player_controller.velocity = Vector2.ZERO
		return
	
	player_controller.velocity = direction * move_speed

func stop_moving():
	is_moving_to_target = false
	player_controller.velocity = Vector2.ZERO