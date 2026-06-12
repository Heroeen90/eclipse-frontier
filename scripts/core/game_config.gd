class_name GameConfig
extends Resource

## Centralized, designer-tunable game balance values.
## Edit these in the Godot Inspector via project.tres without touching code.

@export_group("Player")
@export var player_max_health: int = 100
@export var player_max_stamina: int = 100
@export var player_base_move_speed: float = 150.0
@export var player_sprint_multiplier: float = 1.6
@export var player_stamina_drain_rate: float = 15.0
@export var player_stamina_regen_rate: float = 10.0
@export var player_xp_base_requirement: int = 100
@export var player_xp_growth_factor: float = 1.25
@export var player_max_level: int = 50

@export_group("Inventory")
@export var inventory_max_slots: int = 24
@export var inventory_max_stack_size: int = 99

@export_group("Resource Gathering")
@export var resource_node_respawn_time: float = 60.0
@export var resource_gather_time: float = 1.5
@export var resource_gather_amount_wood: int = 1
@export var resource_gather_amount_stone: int = 1
@export var resource_gather_amount_iron: int = 1
@export var resource_gather_amount_food: int = 1

@export_group("Building Costs")
@export var building_house_cost_wood: int = 50
@export var building_house_cost_stone: int = 20
@export var building_storage_cost_wood: int = 30
@export var building_storage_cost_stone: int = 40
@export var building_mine_cost_wood: int = 40
@export var building_mine_cost_stone: int = 60
@export var building_mine_cost_iron: int = 10
@export var building_farm_cost_wood: int = 35
@export var building_farm_cost_food: int = 5

@export_group("Quests")
@export var quest_reward_xp_multiplier: float = 1.0

@export_group("Save System")
@export var autosave_interval_seconds: float = 120.0
