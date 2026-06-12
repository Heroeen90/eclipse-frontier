extends Node2D

class_name World

@export var map_width = 2000
@export var map_height = 2000
@export var tile_size = 32

var world_manager: WorldManager
var tile_map: TileMap
var player_controller: PlayerController
var camera: Camera2D

var _logger: Logger
var _event_bus: EventBus
var _spawned_resources: Array = []
var _spawned_buildings: Array = []
var _spawned_enemies: Array = []

func _ready():
	_logger = GameManager.instance.logger
	_event_bus = GameManager.instance.event_bus
	
	_setup_world()
	_setup_camera()
	_setup_spawners()
	_connect_signals()
	
	_logger.info("World initialized", "World")

func _setup_world():
	tile_map = $TileMap
	if not tile_map:
		_logger.error("TileMap not found in scene", "World")
	
	world_manager = WorldManager.new()
	add_child(world_manager)
	world_manager.initialize(map_width, map_height, tile_size)

func _setup_camera():
	camera = Camera2D.new()
	camera.make_current()
	add_child(camera)
	camera.zoom = Vector2(1, 1)

func _setup_spawners():
	# Spawn initial resources
	for i in range(5):
		_spawn_random_resource()
	
	# Spawn initial enemies
	for i in range(3):
		_spawn_random_enemy()

func _connect_signals():
	_event_bus.player_position_changed.connect(_on_player_moved)
	_event_bus.building_constructed.connect(_on_building_constructed)
	_event_bus.resource_collected.connect(_on_resource_collected)

func _physics_process(_delta):
	if player_controller:
		camera.global_position = player_controller.global_position

func _spawn_random_resource():
	var resource_types = ["wood", "stone", "iron", "food"]
	var random_type = resource_types[randi() % resource_types.size()]
	var random_pos = Utils.random_position_in_circle(
		Vector2(map_width / 2, map_height / 2),
		min(map_width, map_height) / 2 - 100
	)
	
	world_manager.spawn_resource(random_type, random_pos)

func _spawn_random_enemy():
	var enemy_types = ["skeleton", "goblin"]
	var random_type = enemy_types[randi() % enemy_types.size()]
	var random_pos = Utils.random_position_in_circle(
		Vector2(map_width / 2, map_height / 2),
		min(map_width, map_height) / 2 - 100
	)
	
	world_manager.spawn_enemy(random_type, random_pos)

func _on_player_moved(position: Vector2):
	_check_resource_respawn()
	_check_enemy_spawn()

func _on_building_constructed(building_type: String, position: Vector2):
	_logger.info("Building constructed: %s at %s" % [building_type, position], "World")

func _on_resource_collected(resource_type: String, amount: int):
	_spawn_random_resource()

func _check_resource_respawn():
	if world_manager.get_resource_count() < Constants.MAX_RESOURCES_ON_MAP:
		if randf() < 0.1:  # 10% chance per frame
			_spawn_random_resource()

func _check_enemy_spawn():
	if world_manager.get_enemy_count() < Constants.MAX_ENEMIES_SPAWNED:
		if randf() < 0.05:  # 5% chance per frame
			_spawn_random_enemy()

func get_tile_at_position(position: Vector2) -> Vector2i:
	if tile_map:
		return tile_map.local_to_map(position)
	return Vector2i.ZERO

func is_position_valid(position: Vector2) -> bool:
	return position.x >= 0 and position.x <= map_width and \
		   position.y >= 0 and position.y <= map_height