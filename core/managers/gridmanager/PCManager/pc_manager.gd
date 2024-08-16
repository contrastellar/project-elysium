extends Node
class_name PCManager

var _game_manager: GameManager
var _base_stage: BaseStage
var _positions: Array
var _positions_is_open: Array
var _game_manager_positions_ref: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_player_character(type: String, idx: int) -> void:
	pass
