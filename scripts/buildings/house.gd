extends Building

class_name House

func _ready():
	building_type = BuildingType.HOUSE
	building_name = "House"
	max_health = 150.0
	health = max_health
	construction_time = 10.0
	
	upgrade_cost = {
		"wood": 30,
		"stone": 20
	}
	
	storage_capacity = 200.0
	
	super._ready()

func produce() -> Dictionary:
	# Houses provide happiness/morale boost
	return {
		"happiness": 10
	}