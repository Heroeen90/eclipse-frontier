extends Node

class_name InventoryItem

enum ItemType { RESOURCE, TOOL, CONSUMABLE, QUEST_ITEM }
enum ItemRarity { COMMON, UNCOMMON, RARE, EPIC, LEGENDARY }

var item_id: String
var item_name: String
var item_description: String
var item_type: ItemType
var rarity: ItemRarity
var quantity: int = 1
var max_stack_size: int = 64
var weight: float = 0.0
var icon_path: String = ""
var use_effect: Dictionary = {}
var is_stackable: bool = true

func _init(
	p_id: String = "",
	p_name: String = "",
	p_type: ItemType = ItemType.RESOURCE,
	p_rarity: ItemRarity = ItemRarity.COMMON,
	p_quantity: int = 1
):
	item_id = p_id
	item_name = p_name
	item_type = p_type
	rarity = p_rarity
	quantity = p_quantity

func add_quantity(amount: int) -> int:
	var space_available = max_stack_size - quantity
	var amount_added = min(amount, space_available)
	quantity += amount_added
	return amount_added

func remove_quantity(amount: int) -> bool:
	if quantity >= amount:
		quantity -= amount
		return true
	return false

func is_full() -> bool:
	return quantity >= max_stack_size

func get_space_available() -> int:
	return max_stack_size - quantity

func to_dict() -> Dictionary:
	return {
		"item_id": item_id,
		"item_name": item_name,
		"item_description": item_description,
		"item_type": item_type,
		"rarity": rarity,
		"quantity": quantity,
		"max_stack_size": max_stack_size,
		"weight": weight,
		"icon_path": icon_path,
		"use_effect": use_effect,
		"is_stackable": is_stackable
	}

func from_dict(data: Dictionary) -> void:
	item_id = data.get("item_id", "")
	item_name = data.get("item_name", "")
	item_description = data.get("item_description", "")
	item_type = data.get("item_type", ItemType.RESOURCE)
	rarity = data.get("rarity", ItemRarity.COMMON)
	quantity = data.get("quantity", 1)
	max_stack_size = data.get("max_stack_size", 64)
	weight = data.get("weight", 0.0)
	icon_path = data.get("icon_path", "")
	use_effect = data.get("use_effect", {})
	is_stackable = data.get("is_stackable", true)

func duplicate_item() -> InventoryItem:
	var new_item = InventoryItem.new()
	new_item.from_dict(to_dict())
	return new_item

func get_rarity_color() -> Color:
	match rarity:
		ItemRarity.COMMON:
			return Constants.COLOR_COMMON
		ItemRarity.UNCOMMON:
			return Color.GREEN
		ItemRarity.RARE:
			return Constants.COLOR_RARE
		ItemRarity.EPIC:
			return Constants.COLOR_EPIC
		ItemRarity.LEGENDARY:
			return Constants.COLOR_LEGENDARY
		_:
			return Color.WHITE