extends Node

var log_file_path = "user://game_logs.txt"
var current_log_level = 0
var enable_console_output = true

func _ready():
	pass

func debug(message: String, source: String = ""):
	var formatted = "[DEBUG] [%s]: %s" % [source, message]
	if enable_console_output:
		print(formatted)

func info(message: String, source: String = ""):
	var formatted = "[INFO] [%s]: %s" % [source, message]
	if enable_console_output:
		print(formatted)

func warning(message: String, source: String = ""):
	var formatted = "[WARNING] [%s]: %s" % [source, message]
	if enable_console_output:
		print(formatted)

func error(message: String, source: String = ""):
	var formatted = "[ERROR] [%s]: %s" % [source, message]
	if enable_console_output:
		print(formatted)

func critical(message: String, source: String = ""):
	var formatted = "[CRITICAL] [%s]: %s" % [source, message]
	if enable_console_output:
		print(formatted)