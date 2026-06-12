extends Node

class_name ErrorHandler

var logger: Logger
var event_bus: EventBus
var error_callback: Callable

func _ready():
	logger = GameManager.instance.logger
	event_bus = GameManager.instance.event_bus
	set_process_unhandled_exception(true)

func handle_error(error_message: String, error_code: int = -1, source: String = "Unknown") -> void:
	var full_message = "Error [%s] Code: %d - %s" % [source, error_code, error_message]
	logger.error(full_message, "ErrorHandler")
	
	event_bus.emit_ui_notification(error_message, "error")
	
	if error_callback.is_valid():
		error_callback.call(error_message, error_code)

func handle_warning(warning_message: String, source: String = "Unknown") -> void:
	logger.warning(warning_message, source)
	event_bus.emit_ui_notification(warning_message, "warning")

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		handle_error("Application closing", -1, "System")

func validate_value(value, expected_type: int, error_message: String = "") -> bool:
	if not (value is expected_type):
		var msg = error_message if error_message else "Type mismatch: expected %s" % get_type_name(expected_type)
		handle_error(msg, -1, "Validation")
		return false
	return true

func validate_range(value: float, min_val: float, max_val: float, error_message: String = "") -> bool:
	if value < min_val or value > max_val:
		var msg = error_message if error_message else "Value %f out of range [%f, %f]" % [value, min_val, max_val]
		handle_error(msg, -1, "Validation")
		return false
	return true

func get_type_name(type_hint: int) -> String:
	match type_hint:
		TYPE_INT:
			return "int"
		TYPE_FLOAT:
			return "float"
		TYPE_STRING:
			return "String"
		TYPE_VECTOR2:
			return "Vector2"
		TYPE_RECT2:
			return "Rect2"
		TYPE_OBJECT:
			return "Object"
		_:
			return "Unknown"

func try_execute(callable_func: Callable, error_context: String = "") -> bool:
	try:
		callable_func.call()
		return true
	except:
		handle_error("Execution failed in '%s'" % error_context, -1, "Execution")
		return false