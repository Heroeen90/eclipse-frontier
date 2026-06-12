extends Node

class_name TileManager

var tile_map: TileMap
var tileset: TileSet

var _logger: Logger

func _ready():
	_logger = GameManager.instance.logger
	tile_map = get_parent().get_node_or_null("TileMap")
	if tile_map:
		tileset = tile_map.tile_set

func initialize(tileset_path: String):
	if ResourceLoader.exists(tileset_path):
		tileset = load(tileset_path)
		_logger.info("Tileset loaded: %s" % tileset_path, "TileManager")
	else:
		_logger.error("Tileset not found: %s" % tileset_path, "TileManager")

func set_tile(position: Vector2i, tile_id: int, source_id: int = 0):
	if tile_map:
		tile_map.set_cell(0, position, source_id, Vector2i(tile_id, 0))

func get_tile(position: Vector2i) -> int:
	if tile_map:
		var cell = tile_map.get_cell_source_id(0, position)
		return cell if cell != -1 else -1
	return -1

func get_tile_at_position(world_position: Vector2) -> Vector2i:
	if tile_map:
		return tile_map.local_to_map(world_position)
	return Vector2i.ZERO

func is_collision_tile(position: Vector2i) -> bool:
	var tile_id = get_tile(position)
	return tile_id >= 0  # Adjust based on your collision tiles

func get_walkable_position(position: Vector2) -> Vector2:
	# Find nearest walkable tile
	var tile_pos = get_tile_at_position(position)
	
	# Check surrounding tiles
	for x in range(-2, 3):
		for y in range(-2, 3):
			var check_pos = tile_pos + Vector2i(x, y)
			if not is_collision_tile(check_pos):
				return position
	
	return position