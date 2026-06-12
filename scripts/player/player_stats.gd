extends Node

class_name PlayerStats

# Basic Stats
var max_health = Constants.PLAYER_MAX_HEALTH
var current_health = Constants.PLAYER_MAX_HEALTH
var max_energy = Constants.PLAYER_MAX_ENERGY
var current_energy = Constants.PLAYER_MAX_ENERGY

# Level and Experience
var current_level = 1
var current_experience = 0
var experience_for_next_level = Constants.BASE_EXP_REQUIRED

# Combat Stats
var attack_damage = 10.0
var defense = 5.0
var attack_speed = 1.0

# Movement
var speed = Constants.PLAYER_SPEED
var sprint_speed = Constants.PLAYER_SPRINT_SPEED

# Position
var position = Vector2.ZERO
var is_alive = true

var _logger: Logger
var _event_bus: EventBus
var _health_regen_timer = 0.0
var _energy_regen_timer = 0.0

func _ready():
	_logger = GameManager.instance.logger
	_event_bus = GameManager.instance.event_bus
	initialize()

func initialize():
	current_health = max_health
	current_energy = max_energy
	current_level = 1
	current_experience = 0
	is_alive = true
	_logger.info("PlayerStats initialized", "PlayerStats")

func take_damage(damage: float, source: String = "Unknown") -> void:
	if not is_alive:
		return
	
	var actual_damage = max(1.0, damage - (defense / 10.0))
	current_health -= actual_damage
	
	_event_bus.emit_player_health_changed(current_health)
	_event_bus.emit(EventBus.damage_taken, actual_damage, source)
	
	_logger.debug("Player took %.1f damage from %s" % [actual_damage, source], "PlayerStats")
	
	if current_health <= 0:
		die()

func heal(amount: float) -> void:
	if not is_alive:
		return
	
	var old_health = current_health
	current_health = min(current_health + amount, max_health)
	var healed = current_health - old_health
	
	if healed > 0:
		_event_bus.emit_player_health_changed(current_health)
		_logger.debug("Player healed for %.1f HP" % healed, "PlayerStats")

func consume_energy(amount: float) -> bool:
	if current_energy >= amount:
		current_energy -= amount
		_event_bus.emit_player_energy_changed(current_energy)
		return true
	return false

func restore_energy(amount: float) -> void:
	current_energy = min(current_energy + amount, max_energy)
	_event_bus.emit_player_energy_changed(current_energy)

func gain_experience(amount: int) -> void:
	if not is_alive:
		return
	
	current_experience += amount
	_event_bus.emit(EventBus.player_experience_gained, amount)
	
	_logger.debug("Player gained %d experience" % amount, "PlayerStats")
	
	while current_experience >= experience_for_next_level:
		level_up()

func level_up() -> void:
	current_experience -= experience_for_next_level
	current_level += 1
	
	# Increase stats
	max_health = int(Constants.PLAYER_MAX_HEALTH * (1 + current_level * 0.1))
	current_health = max_health
	
	max_energy = int(Constants.PLAYER_MAX_ENERGY * (1 + current_level * 0.05))
	current_energy = max_energy
	
	attack_damage *= 1.15
	defense *= 1.1
	
	# Calculate next level requirement
	experience_for_next_level = int(Constants.BASE_EXP_REQUIRED * pow(Constants.EXP_SCALE_FACTOR, current_level - 1))
	
	_event_bus.emit(EventBus.player_level_up, current_level)
	_logger.info("Player leveled up to %d!" % current_level, "PlayerStats")
	
	if current_level >= Constants.MAX_LEVEL:
		_logger.info("Player reached maximum level!", "PlayerStats")

func die() -> void:
	is_alive = false
	_event_bus.emit(EventBus.player_died)
	_logger.warning("Player died", "PlayerStats")

func respawn(respawn_position: Vector2 = Vector2.ZERO) -> void:
	is_alive = true
	position = respawn_position
	current_health = max_health
	current_energy = max_energy
	_event_bus.emit(EventBus.player_respawned)
	_logger.info("Player respawned at %s" % respawn_position, "PlayerStats")

func update(delta: float) -> void:
	if not is_alive:
		return
	
	# Health regeneration
	_health_regen_timer += delta
	if _health_regen_timer >= 1.0:
		if current_health < max_health:
			heal(Constants.PLAYER_REGEN_RATE)
		_health_regen_timer = 0.0
	
	# Energy regeneration
	_energy_regen_timer += delta
	if _energy_regen_timer >= 1.0:
		if current_energy < max_energy:
			restore_energy(Constants.PLAYER_ENERGY_REGEN_RATE)
		_energy_regen_timer = 0.0

func get_health_percentage() -> float:
	return float(current_health) / float(max_health)

func get_energy_percentage() -> float:
	return float(current_energy) / float(max_energy)

func get_experience_percentage() -> float:
	return float(current_experience) / float(experience_for_next_level)

func to_dict() -> Dictionary:
	return {
		"level": current_level,
		"experience": current_experience,
		"health": current_health,
		"energy": current_energy,
		"max_health": max_health,
		"max_energy": max_energy,
		"attack_damage": attack_damage,
		"defense": defense,
		"position": {"x": position.x, "y": position.y}
	}

func from_dict(data: Dictionary) -> void:
	current_level = data.get("level", 1)
	current_experience = data.get("experience", 0)
	current_health = data.get("health", max_health)
	current_energy = data.get("energy", max_energy)
	max_health = data.get("max_health", Constants.PLAYER_MAX_HEALTH)
	max_energy = data.get("max_energy", Constants.PLAYER_MAX_ENERGY)
	attack_damage = data.get("attack_damage", 10.0)
	defense = data.get("defense", 5.0)
	
	var pos_data = data.get("position", {})
	position = Vector2(pos_data.get("x", 0), pos_data.get("y", 0))