extends Node

class_name SaveValidator

var _logger: Logger

func _ready():
	_logger = GameManager.instance.logger

func validate_save_data(save_data: Dictionary) -> bool:
	if not save_data:
		_logger.error("Save data is null", "SaveValidator")
		return false
	
	# Check required fields
	if not save_data.has("version"):
		_logger.error("Missing version field", "SaveValidator")
		return false
	
	if not save_data.has("timestamp"):
		_logger.error("Missing timestamp field", "SaveValidator")
		return false
	
	if not save_data.has("checksum"):
		_logger.error("Missing checksum field", "SaveValidator")
		return false
	
	# Validate checksum
	var stored_checksum = save_data.get("checksum", "")
	var data_without_checksum = save_data.duplicate()
	data_without_checksum.erase("checksum")
	
	var calculated_checksum = ChecksumUtil.calculate_dict_checksum(data_without_checksum)
	if stored_checksum != calculated_checksum:
		_logger.error("Checksum mismatch - save file may be corrupted", "SaveValidator")
		return false
	
	# Validate version compatibility
	var saved_version = save_data.get("version", "0.0.0")
	if not _is_version_compatible(saved_version):
		_logger.warning("Save file version %s may not be fully compatible" % saved_version, "SaveValidator")
	
	# Validate player data
	if not _validate_player_data(save_data.get("player", {})):
		_logger.error("Invalid player data", "SaveValidator")
		return false
	
	# Validate resource data
	if not _validate_resources(save_data.get("resources", {})):
		_logger.error("Invalid resources data", "SaveValidator")
		return false
	
	_logger.info("Save data validated successfully", "SaveValidator")
	return true

func validate_save_file(file_path: String) -> bool:
	if not FileAccess.file_exists(file_path):
		_logger.error("Save file not found: %s" % file_path, "SaveValidator")
		return false
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		_logger.error("Cannot open save file: %s" % file_path, "SaveValidator")
		return false
	
	var content = file.get_as_text()
	var json = JSON.new()
	
	if json.parse(content) != OK:
		_logger.error("Invalid JSON in save file", "SaveValidator")
		return false
	
	var save_data = json.get_data()
	return validate_save_data(save_data)

func _is_version_compatible(saved_version: String) -> bool:
	var current_version = Constants.GAME_VERSION
	var saved_parts = saved_version.split(".")
	var current_parts = current_version.split(".")
	
	# At least major version must match
	if saved_parts.size() > 0 and current_parts.size() > 0:
		return saved_parts[0] == current_parts[0]
	
	return true

func _validate_player_data(player_data: Dictionary) -> bool:
	if not player_data.has("level"):
		return false
	
	var level = player_data.get("level", 0)
	if level < 1 or level > Constants.MAX_LEVEL:
		return false
	
	if not player_data.has("health"):
		return false
	
	var health = player_data.get("health", 0)
	if health < 0 or health > 999999:
		return false
	
	return true

func _validate_resources(resources: Dictionary) -> bool:
	var valid_resources = ["wood", "stone", "iron", "food"]
	
	for resource in valid_resources:
		if resources.has(resource):
			var amount = resources.get(resource, 0)
			if amount < 0 or amount > 999999:
				return false
	
	return true