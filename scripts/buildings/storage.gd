extends Building

class_name Storage

var stored_items: Dictionary = {}
var current_storage_used: float = 0.0

func _ready():
	building_type = BuildingType.STORAGE
	building_name = "Storage"
	max_health = 100.0
	health = max_health
	construction_time = 8.0
	
	upgrade_cost = {
		"wood": 40,
		"stone": 30,
		"iron": 10
	}
	
	storage_capacity = 500.0
	
	super._ready()

func add_item(item_type: String, amount: int) -> int:
	var space_available = storage_capacity - current_storage_used
	var amount_stored = min(amount, int(space_available))
	
	if stored_items.has(item_type):
		stored_items[item_type] += amount_stored
	else:
		stored_items[item_type] = amount_stored
	
	current_storage_used += amount_stored
	return amount_stored

func remove_item(item_type: String, amount: int) -> int:
	if not stored_items.has(item_type):
		return 0
	
	var amount_removed = min(amount, stored_items[item_type])
	stored_items[item_type] -= amount_removed
	current_storage_used -= amount_removed
	
	if stored_items[item_type] == 0:
		stored_items.erase(item_type)
	
	return amount_removed

func get_storage_percentage() -> float:
	return current_storage_used / storage_capacity

func produce() -> Dictionary:
	return {
		"storage_expanded": int(storage_capacity)
	}