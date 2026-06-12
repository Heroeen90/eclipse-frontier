extends Camera2D

class_name CameraController

@export var zoom_speed = 0.1
@export var min_zoom = 0.5
@export var max_zoom = 3.0
@export var follow_speed = 200
@export var map_width = 2000
@export var map_height = 2000

var target_position: Vector2 = Vector2.ZERO
var target_zoom = 1.0

var _player_controller: PlayerController

func _ready():
	_player_controller = get_parent().get_node_or_null("PlayerController")
	make_current()

func _process(delta):
	if _player_controller:
		target_position = _player_controller.global_position
	
	_update_camera_position(delta)
	_update_zoom()
	_clamp_camera()

func _update_camera_position(delta):
	global_position = global_position.lerp(target_position, follow_speed * delta / 100)

func _update_zoom():
	if Input.is_action_pressed("ui_scroll_up"):
		target_zoom = move_toward(target_zoom, max_zoom, zoom_speed)
	
	if Input.is_action_pressed("ui_scroll_down"):
		target_zoom = move_toward(target_zoom, min_zoom, zoom_speed)
	
	zoom = zoom.lerp(Vector2(target_zoom, target_zoom), 0.1)

func _clamp_camera():
	var view_width = get_viewport_rect().size.x / zoom.x
	var view_height = get_viewport_rect().size.y / zoom.y
	
	global_position.x = Utils.clamp_value(global_position.x, view_width / 2, map_width - view_width / 2)
	global_position.y = Utils.clamp_value(global_position.y, view_height / 2, map_height - view_height / 2)

func set_zoom_level(level: float):
	target_zoom = Utils.clamp_value(level, min_zoom, max_zoom)

func focus_on_position(position: Vector2):
	target_position = position