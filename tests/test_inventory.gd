extends Node

class_name TestInventory

var tests_passed = 0
var tests_failed = 0

func run_all_tests():
	print("=== Running Inventory Tests ===")
	
	test_add_item()
	test_remove_item()
	test_item_stacking()
	test_inventory_full()
	test_move_items()
	test_inventory_serialization()
	
	print("=== Inventory Tests Complete ===")
	print("Passed: %d | Failed: %d" % [tests_passed, tests_failed])

func test_add_item():
	var inventory = Inventory.new()
	inventory._ready()
	
	var item = InventoryItem.new("wood", "Wood", InventoryItem.ItemType.RESOURCE)
	item.quantity = 5
	
	var result = inventory.add_item(item)
	assert_true(result, "Item should be added successfully")
	assert_equal(inventory.get_item_count("wood"), 5, "Inventory should have 5 wood")
	
	print("✅ test_add_item passed")

func test_remove_item():
	var inventory = Inventory.new()
	inventory._ready()
	
	var item = InventoryItem.new("stone", "Stone", InventoryItem.ItemType.RESOURCE)
	item.quantity = 10
	inventory.add_item(item)
	
	var removed = inventory.remove_item_at_slot(0, 5)
	assert_not_null(removed, "Removed item should not be null")
	assert_equal(inventory.get_item_count("stone"), 5, "Inventory should have 5 stone after removal")
	
	print("✅ test_remove_item passed")

func test_item_stacking():
	var inventory = Inventory.new()
	inventory._ready()
	
	var item1 = InventoryItem.new("iron", "Iron", InventoryItem.ItemType.RESOURCE)
	item1.quantity = 20
	inventory.add_item(item1)
	
	var item2 = InventoryItem.new("iron", "Iron", InventoryItem.ItemType.RESOURCE)
	item2.quantity = 15
	inventory.add_item(item2)
	
	assert_equal(inventory.get_item_count("iron"), 35, "Items should stack correctly")
	
	print("✅ test_item_stacking passed")

func test_inventory_full():
	var inventory = Inventory.new()
	inventory._ready()
	inventory.max_slots = 2
	inventory._initialize_slots()
	
	var item1 = InventoryItem.new("wood", "Wood", InventoryItem.ItemType.RESOURCE)
	item1.is_stackable = false
	inventory.add_item(item1)
	
	var item2 = InventoryItem.new("stone", "Stone", InventoryItem.ItemType.RESOURCE)
	item2.is_stackable = false
	inventory.add_item(item2)
	
	var item3 = InventoryItem.new("iron", "Iron", InventoryItem.ItemType.RESOURCE)
	item3.is_stackable = false
	var result = inventory.add_item(item3)
	
	assert_false(result, "Item should not be added to full inventory")
	assert_true(inventory.is_full(), "Inventory should be full")
	
	print("✅ test_inventory_full passed")

func test_move_items():
	var inventory = Inventory.new()
	inventory._ready()
	
	var item = InventoryItem.new("food", "Food", InventoryItem.ItemType.RESOURCE)
	inventory.add_item(item)
	
	var result = inventory.move_item(0, 5)
	assert_true(result, "Item should move successfully")
	
	var moved_item = inventory.get_item_at_slot(5)
	assert_not_null(moved_item, "Item should be in new slot")
	assert_equal(moved_item.item_id, "food", "Moved item should be food")
	
	print("✅ test_move_items passed")

func test_inventory_serialization():
	var inventory = Inventory.new()
	inventory._ready()
	
	var item = InventoryItem.new("wood", "Wood", InventoryItem.ItemType.RESOURCE)
	item.quantity = 25
	inventory.add_item(item)
	
	var dict = inventory.to_dict()
	
	var new_inventory = Inventory.new()
	new_inventory._ready()
	new_inventory.from_dict(dict)
	
	assert_equal(new_inventory.get_item_count("wood"), 25, "Serialized inventory should match original")
	
	print("✅ test_inventory_serialization passed")

func assert_true(condition: bool, message: String):
	if condition:
		tests_passed += 1
	else:
		tests_failed += 1
		print("❌ FAIL: %s" % message)

func assert_false(condition: bool, message: String):
	assert_true(!condition, message)

func assert_equal(value, expected, message: String):
	assert_true(value == expected, "%s (expected: %s, got: %s)" % [message, expected, value])

func assert_not_null(value, message: String):
	assert_true(value != null, message)