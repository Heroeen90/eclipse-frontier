extends Node

class_name Inventory

var slots: Array[InventoryItem] = []
var max_slots = Constants.MAX_INVENTORY_SLOTS
var current_weight = 0.0
var max_weight = 100.0

var _logger: Logger
var _event_bus: EventBus

func _ready():
	_logger = GameManager.instance.logger
	_event_bus = GameManager.instance.event_bus
	_initialize_slots()

func _initialize_slots():
	slots.clear()
	for i in range(max_slots):
		slots.append(null)

func add_item(item: InventoryItem) -> bool:
	if not item:
		return false
	
	# Try to stack with existing item
	if item.is_stackable:
		for slot_item in slots:
			if slot_item and slot_item.item_id == item.item_id:
				var added = slot_item.add_quantity(item.quantity)
				if added == item.quantity:
					_event_bus.emit_inventory_item_added(item, item.quantity)
					_logger.debug("Item stacked: %s" % item.item_name, "Inventory")
					return true
				else:
					item.quantity -= added
	
	# Find empty slot
	for i in range(slots.size()):
		if slots[i] == null:
			var item_copy = item.duplicate_item()
			slots[i] = item_copy
			current_weight += item_copy.weight * item_copy.quantity
			_event_bus.emit_inventory_item_added(item_copy, item_copy.quantity)
			_logger.debug("Item added to slot %d: %s" % [i, item.item_name], "Inventory")
			return true
	
	_logger.warning("Inventory full, could not add item: %s" % item.item_name, "Inventory")
	_event_bus.emit(EventBus.inventory_full)
	return false

func remove_item_at_slot(slot_index: int, quantity: int = 1) -> InventoryItem:
	if not _is_valid_slot(slot_index):
		return null
	
	var item = slots[slot_index]
	if not item:
		return null
	
	var removed_item = item.duplicate_item()
	removed_item.quantity = min(quantity, item.quantity)
	
	if item.remove_quantity(quantity):
		current_weight -= item.weight * quantity
		if item.quantity == 0:
			slots[slot_index] = null
		_event_bus.emit_inventory_item_removed(removed_item, removed_item.quantity)
		_logger.debug("Item removed from slot %d: %s" % [slot_index, item.item_name], "Inventory")
		return removed_item
	
	return null

func get_item_count(item_id: String) -> int:
	var count = 0
	for item in slots:
		if item and item.item_id == item_id:
			count += item.quantity
	return count

func has_item(item_id: String, quantity: int = 1) -> bool:
	return get_item_count(item_id) >= quantity

func get_item_at_slot(slot_index: int) -> InventoryItem:
	if _is_valid_slot(slot_index):
		return slots[slot_index]
	return null

func move_item(from_slot: int, to_slot: int) -> bool:
	if not _is_valid_slot(from_slot) or not _is_valid_slot(to_slot):
		return false
	
	var temp = slots[from_slot]
	slots[from_slot] = slots[to_slot]
	slots[to_slot] = temp
	
	return true

func swap_items(slot1: int, slot2: int) -> bool:
	return move_item(slot1, slot2)

func clear():
	_initialize_slots()
	current_weight = 0.0

func get_empty_slots() -> int:
	var count = 0
	for item in slots:
		if item == null:
			count += 1
	return count

func is_full() -> bool:
	return get_empty_slots() == 0

func get_weight_percentage() -> float:
	return current_weight / max_weight

func _is_valid_slot(slot_index: int) -> bool:
	return slot_index >= 0 and slot_index < slots.size()

func to_dict() -> Dictionary:
	var items_data = []
	for i in range(slots.size()):
		if slots[i]:
			items_data.append({
				"slot": i,
				"item": slots[i].to_dict()
			})
	
	return {
		"max_slots": max_slots,
		"current_weight": current_weight,
		"max_weight": max_weight,
		"items": items_data
	}

func from_dict(data: Dictionary) -> void:
	_initialize_slots()
	max_slots = data.get("max_slots", Constants.MAX_INVENTORY_SLOTS)
	current_weight = data.get("current_weight", 0.0)
	max_weight = data.get("max_weight", 100.0)
	
	for item_data in data.get("items", []):
		var slot = item_data.get("slot", 0)
		var item_dict = item_data.get("item", {})
		var item = InventoryItem.new()
		item.from_dict(item_dict)
		if slot < slots.size():
			slots[slot] = item