extends Node2D
class_name Deck

var tile_map: DeckTileMap
var game_manager: GameManager
var stage: BaseStage
var _positions: Array
var _positions_is_open: Array
var _game_manager_positions_ref: Array

var _test_sprite: PackedScene = preload("res://assets/pcs/lancer_pc_tile/lancer_pc_tile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(find_child('TileMapLayer') is TileMapLayer)
	tile_map = find_child('TileMapLayer')
	
	game_manager = get_parent()
	stage = game_manager.stage
	
	_game_manager_positions_ref = game_manager.pc_types.duplicate()
	var j = 0
	for i in _game_manager_positions_ref:
		add_player_character(i, j)
		j += 1
	
	return


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func normalize(pos: Vector2) -> Vector2:
	return pos - position

func add_player_character(type: String, idx: int) -> void:
	type = type.to_lower()
	if type == "test":
		var player_char: BasePC = _test_sprite.instantiate()
		player_char.position = tile_map.return_global_grid_position(tile_map.map_to_local(Vector2(idx, 0)))
		add_child(player_char)
		_positions.append(player_char)
		_positions_is_open.append(true)


func is_droppable(pos: Vector2) -> bool:
	return tile_map.is_droppable(normalize(pos))
	


func return_global_grid_position(pos: Vector2) -> Vector2:
	return tile_map.return_global_grid_position(pos)
