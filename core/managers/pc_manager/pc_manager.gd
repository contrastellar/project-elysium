extends Control
class_name PCManager

var pc_deck: PCDeck
var _game_manager: GameManager
var _base_stage: BaseStage
var _positions: Array
var _positions_is_open: Array
var _game_manager_positions_ref: Array

var _test_sprite: Resource = preload("res://assets/pcs/test/lancer_pc_tile.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(get_node('Deck') is PCDeck)
	pc_deck = get_node('Deck')
	_base_stage = get_parent().get_parent()
	_game_manager = _base_stage.game_manager
	_game_manager_positions_ref = _game_manager.pc_types.duplicate()
	var j = 0
	for i in _game_manager_positions_ref:
		add_player_character(i, j)
		j += 1
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func add_player_character(type: String, idx: int) -> void:
	type = type.to_lower()
	if type == "test":
		var player_char: PCTile = _test_sprite.instantiate()
		player_char.position = pc_deck.return_global_grid_position(pc_deck.map_to_local(Vector2(idx, 0)))
		add_child(player_char)
		print("Appending")
		_positions.append(player_char)
		_positions_is_open.append(true)
