extends Building

class_name Farm

var crop_produced: int = 0
var production_timer: float = 0.0
var production_interval: float = 8.0

func _ready():
	building_type = BuildingType.FARM
	building_name = "Farm"
	max_health = 100.0
	health = max_health
	construction_time = 12.0
	
	upgrade_cost = {
		"wood": 35,
		"stone": 25
	}
	
	production_rate = 1.5
	
	super._ready()

func _physics_process(delta):
	super._physics_process(delta)
	
	if not is_under_construction:
		_update_production(delta)

func _update_production(delta):
	production_timer += delta
	
	if production_timer >= production_interval / production_rate:
		produce()
		production_timer = 0.0

func produce() -> Dictionary:
	var resource_manager = GameManager.instance.resource_manager
	var food_produced = int(8 * production_rate)
	
	resource_manager.add_resource("food", food_produced)
	crop_produced += food_produced
	
	_logger.debug("Farm produced %d food" % food_produced, "Farm")
	
	return {
		"food": food_produced
	}