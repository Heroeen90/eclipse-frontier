extends Node2D

class_name ResourceSpawner

var resource_type: String = "wood"
var resource_amount: int = 10
var spawn_position: Vector2 = Vector2.ZERO
var collected = false

var _logger: Logger
var _event_bus: EventBus
var _sprite: Sprite2D

func _ready():
	_logger = GameManager.instance.logger
	_event_bus = GameManager.instance.event_bus
	
	_setup_visuals()

func _setup_visuals():
	_sprite = Sprite2D.new()
	add_child(_sprite)
	
	match resource_type:
		"wood":
			_sprite.modulate = Color.BROWN
		"stone":
			_sprite.modulate = Color.GRAY
		"iron":
			_sprite.modulate = Color.DARK_GRAY
		"food":
			_sprite.modulate = Color.GREEN
	
	var circle_mesh = CircleMesh.new()
	circle_mesh.radius = 10
	_sprite.set_mesh(circle_mesh)

func initialize(type: String, amount: int, pos: Vector2):
	resource_type = type
	resource_amount = amount
	spawn_position = pos
	global_position = pos

func _on_area_entered(area):
	if collected:
		return
	
	var player_stats = GameManager.instance.player_manager
	if player_stats and player_stats.position.distance_to(global_position) < 50:
		collect()

func collect():
	if collected:
		return
	
	collected = true
	var resource_manager = GameManager.instance.resource_manager
	resource_manager.add_resource(resource_type, resource_amount)
	_logger.debug("Resource collected: %d %s" % [resource_amount, resource_type], "ResourceSpawner")
	queue_free()