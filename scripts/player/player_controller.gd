extends CharacterBody2D

class_name PlayerController

@export var acceleration = 1500
@export var friction = 1200
@export var max_speed = 200

var is_moving = false
var is_sprinting = false
var current_direction = Vector2.ZERO

var _player_stats: PlayerStats
var _logger: Logger
var _event_bus: EventBus
var _animation_player: AnimationPlayer
var _collision_shape: CollisionShape2D

func _ready():
	_player_stats = GameManager.instance.player_manager
	_logger = GameManager.instance.logger
	_event_bus = GameManager.instance.event_bus
	
	_animation_player = $AnimationPlayer
	_collision_shape = $CollisionShape2D
	
	_connect_signals()
	_logger.info("PlayerController ready", "PlayerController")

func _connect_signals():
	_event_bus.player_died.connect(_on_player_died)
	_event_bus.player_respawned.connect(_on_player_respawned)

func _physics_process(delta):
	if not _player_stats.is_alive:
		return
	
	_handle_input()
	_update_movement(delta)
	_update_animation()
	
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	move_and_slide()
	
	_player_stats.position = global_position

func _handle_input():
	current_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	is_sprinting = Input.is_action_pressed("ui_sprint")
	
	if current_direction != Vector2.ZERO:
		is_moving = true
	else:
		is_moving = false

func _update_movement(delta):
	if current_direction == Vector2.ZERO:
		return
	
	var target_speed = Constants.PLAYER_SPRINT_SPEED if is_sprinting else Constants.PLAYER_SPEED
	
	# Check energy for sprinting
	if is_sprinting:
		if not _player_stats.consume_energy(Constants.PLAYER_SPRINT_ENERGY_DRAIN * delta):
			is_sprinting = false
			target_speed = Constants.PLAYER_SPEED
	
	velocity = velocity.move_toward(current_direction.normalized() * target_speed, acceleration * delta)

func _update_animation():
	if not _animation_player:
		return
	
	if is_moving:
		if is_sprinting:
			_animation_player.play("run")
		else:
			_animation_player.play("walk")
	else:
		_animation_player.play("idle")
	
	# Flip sprite based on direction
	if current_direction.x < 0:
		scale.x = -1
	elif current_direction.x > 0:
		scale.x = 1

func _on_player_died():
	velocity = Vector2.ZERO
	_animation_player.play("idle")
	collision_layer = 0
	collision_mask = 0

func _on_player_respawned():
	collision_layer = 1
	collision_mask = 1
	global_position = _player_stats.position

func knockback(force: Vector2, duration: float = 0.2):
	velocity = force
	await get_tree().create_timer(duration).timeout
	velocity = Vector2.ZERO