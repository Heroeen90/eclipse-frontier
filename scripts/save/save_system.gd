extends Node

class_name SaveSystem

var save_path = Constants.SAVE_FILE_PATH
var save_file_name = Constants.SAVE_FILE_NAME
var backup_enabled = true

var _logger: Logger
var _event_bus: EventBus
var _validator: SaveValidator
var _autosave_timer = 0.0

func _ready():
	_logger = GameManager.instance.logger
	_event_bus = GameManager.instance.event_bus
	_validator = SaveValidator.new()
	add_child(_validator)
	
	_ensure_save_directory()
	_logger.info("SaveSystem initialized", "SaveSystem")

func _ensure_save_directory():
	var dir = DirAccess.open(save_path)
	if dir == null:
		DirAccess.make_absolute_path(save_path)

func save_game(save_data: Dictionary, slot: int = 0) -> bool:
	try:
		var save_obj = SaveData.new()
		save_obj.version = save_data.get("version", Constants.GAME_VERSION)
		save_obj.timestamp = Time.get_datetime_string_from_system()
		save_obj.playtime = save_data.get("playtime", 0.0)
		save_obj.level = save_data.get("level", 1)
		save_obj.player = save_data.get("player", {})
		save_obj.inventory = save_data.get("inventory", {})
		save_obj.quests = save_data.get("quests", {})
		save_obj.resources = save_data.get("resources", {})
		
		var save_dict = save_obj.to_dict()
		var json_string = JSON.stringify(save_dict)
		
		# Create backup
		if backup_enabled:
			_create_backup(slot)
		
		# Encrypt if enabled
		if Constants.SAVE_ENCRYPTION_ENABLED:
			json_string = EncryptionUtil.encrypt_data(json_string)
		
		# Write to file
		var file_path = _get_save_file_path(slot)
		var file = FileAccess.open(file_path, FileAccess.WRITE)
		
		if file == null:
			_logger.error("Cannot open save file for writing: %s" % file_path, "SaveSystem")
			return false
		
		file.store_string(json_string)
		
		_logger.info("Game saved to slot %d at %s" % [slot, file_path], "SaveSystem")
		_event_bus.emit(EventBus.game_saved, slot)
		
		return true
		
	except:
		_logger.error("Error saving game to slot %d" % slot, "SaveSystem")
		return false

func load_game(slot: int = 0) -> Dictionary:
	try:
		var file_path = _get_save_file_path(slot)
		
		if not FileAccess.file_exists(file_path):
			_logger.warning("Save file not found: %s" % file_path, "SaveSystem")
			return {}
		
		# Validate file before loading
		if not _validator.validate_save_file(file_path):
			_logger.error("Save file validation failed", "SaveSystem")
			_event_bus.emit(EventBus.save_corrupted)
			return {}
		
		var file = FileAccess.open(file_path, FileAccess.READ)
		if file == null:
			_logger.error("Cannot open save file: %s" % file_path, "SaveSystem")
			return {}
		
		var content = file.get_as_text()
		
		# Decrypt if enabled
		if Constants.SAVE_ENCRYPTION_ENABLED:
			content = EncryptionUtil.decrypt_data(content)
		
		var json = JSON.new()
		if json.parse(content) != OK:
			_logger.error("Invalid JSON in save file", "SaveSystem")
			return {}
		
		var save_data = json.get_data()
		
		# Final validation
		if not _validator.validate_save_data(save_data):
			_logger.error("Save data validation failed", "SaveSystem")
			return {}
		
		_logger.info("Game loaded from slot %d" % slot, "SaveSystem")
		return save_data
		
	except:
		_logger.error("Error loading game from slot %d" % slot, "SaveSystem")
		return {}

func has_save_file(slot: int = 0) -> bool:
	var file_path = _get_save_file_path(slot)
	return FileAccess.file_exists(file_path)

func delete_save(slot: int = 0) -> bool:
	try:
		var file_path = _get_save_file_path(slot)
		if FileAccess.file_exists(file_path):
			DirAccess.remove_absolute(file_path)
			_logger.info("Save file deleted: %s" % file_path, "SaveSystem")
			return true
		return false
	except:
		_logger.error("Error deleting save file", "SaveSystem")
		return false

func get_save_info(slot: int = 0) -> Dictionary:
	var save_data = load_game(slot)
	if save_data.is_empty():
		return {}
	
	return {
		"level": save_data.get("level", 0),
		"playtime": save_data.get("playtime", 0.0),
		"timestamp": save_data.get("timestamp", ""),
		"version": save_data.get("version", "")
	}

func get_all_saves() -> Array[Dictionary]:
	var saves = []
	for slot in range(10):
		var info = get_save_info(slot)
		if not info.is_empty():
			info["slot"] = slot
			saves.append(info)
	return saves

func _create_backup(slot: int):
	var file_path = _get_save_file_path(slot)
	var backup_path = _get_backup_file_path(slot)
	
	if FileAccess.file_exists(file_path):
		if FileAccess.file_exists(backup_path):
			DirAccess.remove_absolute(backup_path)
		DirAccess.rename_absolute(file_path, backup_path)

func _get_save_file_path(slot: int) -> String:
	return save_path + "save_%d.dat" % slot

func _get_backup_file_path(slot: int) -> String:
	return save_path + "save_%d_backup.dat" % slot

func _process(delta):
	_autosave_timer += delta
	if _autosave_timer >= Constants.AUTOSAVE_INTERVAL:
		_autosave_timer = 0.0
		if GameManager.instance:
			GameManager.instance.save_game()

func update(_delta: float):
	pass