extends Node

func _ready():
	pass

func handle_error(error_message: String, error_code: int = -1, source: String = "Unknown") -> void:
	var full_message = "Error [%s] Code: %d - %s" % [source, error_code, error_message]
	print(full_message)

func handle_warning(warning_message: String, source: String = "Unknown") -> void:
	print("[WARNING] [%s]: %s" % [source, warning_message])

func validate_range(value: float, min_val: float, max_val: float) -> bool:
	return value >= min_val and value <= max_val