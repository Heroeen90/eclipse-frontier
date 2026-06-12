extends Building

class_name Mine

var ore_produced: int = 0
var production_timer: float = 0.0
var production_interval: float = 5.0

func _ready():
	building_type = BuildingType.MINE
	building_name = "Mine"
	max_health = 120.0
	health = max_health
	construction_time = 15.0
	
	upgrade_cost = {
		"wood": 50,
		"stone": 40,
		"iron": 20
	}
	
	production_rate = 2.0
	
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
	var iron_produced = int(5 * production_rate)
	
	resource_manager.add_resource("iron", iron_produced)
	ore_produced += iron_produced
	
	_logger.debug("Mine produced %d iron" % iron_produced, "Mine")
	
	return {
		"iron": iron_produced
	}