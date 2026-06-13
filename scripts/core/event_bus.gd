extends Node

signal player_health_changed(new_health: float)
signal player_energy_changed(new_energy: float)
signal player_level_up(new_level: int)
signal player_experience_gained(amount: int)
signal player_died()
signal player_respawned()
signal player_position_changed(position: Vector2)

signal inventory_item_added(item: Object, amount: int)
signal inventory_item_removed(item: Object, amount: int)
signal inventory_item_used(item: Object)
signal inventory_full()

signal resource_collected(resource_type: String, amount: int)
signal resource_spawned(position: Vector2, resource_type: String)

signal building_constructed(building_type: String, position: Vector2)
signal building_destroyed(building_type: String, position: Vector2)
signal building_upgraded(building_type: String)
signal building_damaged(building_type: String, damage: float)

signal quest_started(quest_id: String)
signal quest_completed(quest_id: String)
signal quest_failed(quest_id: String)
signal quest_progress_changed(quest_id: String, progress: float)
signal quest_reward_claimed(quest_id: String, reward: Dictionary)

signal game_paused()
signal game_resumed()
signal game_over()
signal game_won()
signal game_saved(slot: int)
signal game_loaded(slot: int)
signal save_corrupted()

signal enemy_spawned(enemy_id: String, position: Vector2)
signal enemy_defeated(enemy_id: String, reward: int)
signal damage_taken(amount: float, source: String)

signal ui_menu_opened(menu_name: String)
signal ui_menu_closed(menu_name: String)
signal ui_notification_shown(message: String, type: String)

signal difficulty_changed(difficulty: String)
signal sound_volume_changed(volume: float)
signal graphics_quality_changed(quality: String)

func emit_player_health_changed(health: float):
	player_health_changed.emit(health)

func emit_player_energy_changed(energy: float):
	player_energy_changed.emit(energy)

func emit_resource_collected(resource_type: String, amount: int):
	resource_collected.emit(resource_type, amount)

func emit_resource_spawned(position: Vector2, resource_type: String):
	resource_spawned.emit(position, resource_type)

func emit_building_constructed(building_type: String, position: Vector2):
	building_constructed.emit(building_type, position)

func emit_enemy_spawned(enemy_id: String, position: Vector2):
	enemy_spawned.emit(enemy_id, position)

func emit_enemy_defeated(enemy_id: String, reward: int):
	enemy_defeated.emit(enemy_id, reward)

func emit_ui_notification(message: String, type: String = "info"):
	ui_notification_shown.emit(message, type)

func emit_ui_menu_opened(menu_name: String):
	ui_menu_opened.emit(menu_name)

func emit_game_paused():
	game_paused.emit()

func emit_game_resumed():
	game_resumed.emit()