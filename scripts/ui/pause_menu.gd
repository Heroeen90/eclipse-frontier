extends CanvasLayer

class_name PauseMenu

@onready var control = $Control
@onready var resume_button = $Control/VBoxContainer/ResumeButton
@onready var settings_button = $Control/VBoxContainer/SettingsButton
@onready var save_button = $Control/VBoxContainer/SaveButton
@onready var load_button = $Control/VBoxContainer/LoadButton
@onready var main_menu_button = $Control/VBoxContainer/MainMenuButton
@onready var quit_button = $Control/VBoxContainer/QuitButton

var is_paused = false
var _logger: Logger
var _event_bus: EventBus

func _ready():
	_logger = GameManager.instance.logger
	_event_bus = GameManager.instance.event_bus
	
	visible = false
	_connect_signals()
	
	_logger.info("PauseMenu initialized", "PauseMenu")

func _connect_signals():
	resume_button.pressed.connect(_on_resume_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	save_button.pressed.connect(_on_save_pressed)
	load_button.pressed.connect(_on_load_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	_event_bus.game_paused.connect(_on_game_paused)
	_event_bus.game_resumed.connect(_on_game_resumed)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if is_paused:
			_on_resume_pressed()
		else:
			GameManager.instance.pause_game()

func _on_resume_pressed():
	GameManager.instance.resume_game()
	_logger.debug("Game resumed from pause menu", "PauseMenu")

func _on_settings_pressed():
	_logger.debug("Settings opened from pause menu", "PauseMenu")

func _on_save_pressed():
	if GameManager.instance.save_game():
		_event_bus.emit_ui_notification("Game saved successfully", "success")
		_logger.info("Game saved from pause menu", "PauseMenu")
	else:
		_event_bus.emit_ui_notification("Failed to save game", "error")

func _on_load_pressed():
	if GameManager.instance.load_game():
		_event_bus.emit_ui_notification("Game loaded successfully", "success")
		_logger.info("Game loaded from pause menu", "PauseMenu")
	else:
		_event_bus.emit_ui_notification("Failed to load game", "error")

func _on_main_menu_pressed():
	GameManager.instance.resume_game()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_quit_pressed():
	GameManager.instance.quit_game()

func _on_game_paused():
	visible = true
	is_paused = true
	_logger.debug("Pause menu shown", "PauseMenu")

func _on_game_resumed():
	visible = false
	is_paused = false
	_logger.debug("Pause menu hidden", "PauseMenu")