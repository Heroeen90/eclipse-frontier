extends Node

class_name EventBus

# Player Events
signal player_health_changed(new_health: float)
signal player_energy_changed(new_energy: float)
signal player_level_up(new_level: int)
signal player_experience_gained(amount: int)
signal player_died()
signal player_respawned()
signal player_position_changed(position: Vector2)

# Inventory Events
signal inventory_item_added(item: InventoryItem, amount: int)
signal inventory_item_removed(item: InventoryItem, amount: int)
signal inventory_item_used(item: InventoryItem)
signal inventory_slot_changed(slot: int, item: InventoryItem)
signal inventory_full()

# Resource Events
signal resource_collected(resource_type: String, amount: int)
signal resource_depleted()
signal resource_spawned(position: Vector2, resource_type: String)

# Building Events
signal building_constructed(building_type: String, position: Vector2)
signal building_destroyed(building_type: String, position: Vector2)
signal building_upgraded(building_type: String)
signal building_damaged(building_type: String, damage: float)

# Quest Events
signal quest_started(quest_id: String)
signal quest_completed(quest_id: String)
signal quest_failed(quest_id: String)
signal quest_progress_changed(quest_id: String, progress: float)
signal quest_reward_claimed(quest_id: String, reward: Dictionary)

# Game State Events
signal game_paused()
signal game_resumed()
signal game_over()
signal game_won()
signal difficulty_changed(difficulty: String)

# Combat Events
signal enemy_spawned(enemy_id: String, position: Vector2)
signal enemy_defeated(enemy_id: String, reward: int)
signal damage_taken(amount: float, source: String)
signal damage_dealt(amount: float, target: String)

# UI Events
signal ui_menu_opened(menu_name: String)
signal ui_menu_closed(menu_name: String)
signal ui_notification_shown(message: String, type: String)

# Save/Load Events
signal game_saved(slot: int)
signal game_loaded(slot: int)
signal save_corrupted()

# Settings Events
signal setting_changed(setting_name: String, new_value)
signal graphics_quality_changed(quality: String)
signal sound_volume_changed(volume: float)

func emit_player_health_changed(health: float):
	player_health_changed.emit(health)

func emit_player_energy_changed(energy: float):
	player_energy_changed.emit(energy)

func emit_inventory_item_added(item: InventoryItem, amount: int):
	inventory_item_added.emit(item, amount)

func emit_building_constructed(building_type: String, position: Vector2):
	building_constructed.emit(building_type, position)

func emit_quest_completed(quest_id: String):
	quest_completed.emit(quest_id)

func emit_resource_collected(resource_type: String, amount: int):
	resource_collected.emit(resource_type, amount)

func emit_ui_notification(message: String, type: String = "info"):
	ui_notification_shown.emit(message, type)

func emit_game_paused():
	game_paused.emit()

func emit_game_resumed():
	game_resumed.emit()