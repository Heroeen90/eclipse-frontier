extends Node

class_name BuildingManager

var buildings_data: Dictionary = {}
var player_buildings: Array[Dictionary] = []

var _logger: Logger
var _event_bus: EventBus

func _ready():
	_logger = GameManager.instance.logger
	_event_bus = GameManager.instance.event_bus
	_load_buildings_data()

func _load_buildings_data():
	var file = FileAccess.open("res://data/buildings_data.json", FileAccess.READ)
	if file:
		var json = JSON.new()
		var content = file.get_as_text()
		if json.parse(content) == OK:
			buildings_data = json.get_data()

func can_build(building_type: String, position: Vector2) -> bool:
	if not buildings_data.has(building_type):
		_logger.warning("Building type not found: %s" % building_type, "BuildingManager")
		return false
	
	# Check if position is valid
	if not _is_valid_build_position(position):
		_logger.warning("Invalid build position", "BuildingManager")
		return false
	
	# Check resources
	var building_data = buildings_data[building_type]
	var cost = building_data.get("cost", {})
	var resource_manager = GameManager.instance.resource_manager
	
	if not resource_manager.has_resources(cost):
		_logger.warning("Insufficient resources to build %s" % building_type, "BuildingManager")
		return false
	
	return true

func build_building(building_type: String, position: Vector2) -> bool:
	if not can_build(building_type, position):
		return false
	
	var building_data = buildings_data[building_type]
	var cost = building_data.get("cost", {})
	
	var resource_manager = GameManager.instance.resource_manager
	if not resource_manager.consume_resources(cost):
		return false
	
	var new_building = {
		"type": building_type,
		"position": position,
		"health": building_data.get("health", 100),
		"level": 1,
		"construction_time": building_data.get("construction_time", 5.0),
		"id": "building_%d" % randi()
	}
	
	player_buildings.append(new_building)
	_event_bus.emit_building_constructed(building_type, position)
	_logger.info("Building constructed: %s at %s" % [building_type, position], "BuildingManager")
	
	return true

func _is_valid_build_position(position: Vector2) -> bool:
	# Check if too close to other buildings
	for building in player_buildings:
		if position.distance_to(building["position"]) < 100:
			return false
	
	# Check if within map bounds (assuming world is 2000x2000)
	if position.x < 0 or position.x > 2000 or position.y < 0 or position.y > 2000:
		return false
	
	return true

func get_building_info(building_type: String) -> Dictionary:
	return buildings_data.get(building_type, {})

func upgrade_building(building_id: String) -> bool:
	for building in player_buildings:
		if building["id"] == building_id:
			building["level"] += 1
			_event_bus.emit(EventBus.building_upgraded, building["type"])
			return true
	return false

func get_player_buildings() -> Array[Dictionary]:
	return player_buildings

func to_dict() -> Dictionary:
	return {"buildings": player_buildings}

func from_dict(data: Dictionary):
	player_buildings = data.get("buildings", [])