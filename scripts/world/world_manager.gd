extends Node

class_name WorldManager

var map_width = 2000
var map_height = 2000
var tile_size = 32

var resources: Array[Dictionary] = []
var buildings: Array[Dictionary] = []
var enemies: Array[Dictionary] = []

var _logger: Logger
var _event_bus: EventBus

func _ready():
	_logger = GameManager.instance.logger
	_event_bus = GameManager.instance.event_bus

func initialize(width: int, height: int, tile_sz: int):
	map_width = width
	map_height = height
	tile_size = tile_sz
	_logger.info("WorldManager initialized: %dx%d with tile size %d" % [width, height, tile_sz], "WorldManager")

func spawn_resource(resource_type: String, position: Vector2) -> Dictionary:
	var resource_data = {
		"type": resource_type,
		"position": position,
		"amount": randi_range(5, 20),
		"id": "resource_%d" % hash(Vector2(randf(), randf()))
	}
	
	resources.append(resource_data)
	_event_bus.emit_resource_spawned(position, resource_type)
	_logger.debug("Resource spawned: %s at %s" % [resource_type, position], "WorldManager")
	
	return resource_data

func collect_resource(resource_id: String) -> bool:
	for i in range(resources.size()):
		if resources[i]["id"] == resource_id:
			var resource_type = resources[i]["type"]
			var amount = resources[i]["amount"]
			resources.remove_at(i)
			_event_bus.emit_resource_collected(resource_type, amount)
			return true
	return false

func get_nearby_resources(position: Vector2, range_distance: float) -> Array[Dictionary]:
	var nearby = []
	for resource in resources:
		if Utils.is_position_in_range(position, resource["position"], range_distance):
			nearby.append(resource)
	return nearby

func spawn_building(building_type: String, position: Vector2, owner_id: String = "player") -> Dictionary:
	if buildings.size() >= Constants.MAX_BUILDING_COUNT:
		_logger.warning("Maximum building count reached", "WorldManager")
		return {}
	
	var building_data = {
		"type": building_type,
		"position": position,
		"owner": owner_id,
		"health": Constants.BUILDING_BASE_HEALTH,
		"level": 1,
		"id": "building_%d" % hash(Vector2(randf(), randf())),
		"construction_progress": 0.0
	}
	
	buildings.append(building_data)
	_event_bus.emit_building_constructed(building_type, position)
	_logger.info("Building spawned: %s at %s" % [building_type, position], "WorldManager")
	
	return building_data

func get_buildings_near(position: Vector2, range_distance: float) -> Array[Dictionary]:
	var nearby = []
	for building in buildings:
		if Utils.is_position_in_range(position, building["position"], range_distance):
			nearby.append(building)
	return nearby

func destroy_building(building_id: String) -> bool:
	for i in range(buildings.size()):
		if buildings[i]["id"] == building_id:
			var building_type = buildings[i]["type"]
			var position = buildings[i]["position"]
			buildings.remove_at(i)
			_event_bus.emit(EventBus.building_destroyed, building_type, position)
			return true
	return false

func damage_building(building_id: String, damage: float) -> bool:
	for building in buildings:
		if building["id"] == building_id:
			building["health"] -= damage
			_event_bus.emit(EventBus.building_damaged, building["type"], damage)
			
			if building["health"] <= 0:
				destroy_building(building_id)
			
			return true
	return false

func spawn_enemy(enemy_type: String, position: Vector2) -> Dictionary:
	if enemies.size() >= Constants.MAX_ENEMIES_SPAWNED:
		return {}
	
	var enemy_data = {
		"type": enemy_type,
		"position": position,
		"health": 30,
		"id": "enemy_%d" % hash(Vector2(randf(), randf())),
		"experience_reward": 50
	}
	
	enemies.append(enemy_data)
	_event_bus.emit_enemy_spawned(enemy_data["id"], position)
	_logger.debug("Enemy spawned: %s at %s" % [enemy_type, position], "WorldManager")
	
	return enemy_data

func get_nearby_enemies(position: Vector2, range_distance: float) -> Array[Dictionary]:
	var nearby = []
	for enemy in enemies:
		if Utils.is_position_in_range(position, enemy["position"], range_distance):
			nearby.append(enemy)
	return nearby

func defeat_enemy(enemy_id: String) -> int:
	for i in range(enemies.size()):
		if enemies[i]["id"] == enemy_id:
			var exp_reward = enemies[i]["experience_reward"]
			enemies.remove_at(i)
			_event_bus.emit_enemy_defeated(enemy_id, exp_reward)
			_logger.debug("Enemy defeated: %s (reward: %d exp)" % [enemy_id, exp_reward], "WorldManager")
			return exp_reward
	return 0

func get_resource_count() -> int:
	return resources.size()

func get_building_count() -> int:
	return buildings.size()

func get_enemy_count() -> int:
	return enemies.size()

func get_world_data() -> Dictionary:
	return {
		"resources": resources,
		"buildings": buildings,
		"enemies": enemies
	}

func update(_delta: float):
	pass