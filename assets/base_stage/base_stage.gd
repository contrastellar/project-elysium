extends Node
class_name BaseStage

var scene_manager: SceneManager
var game_manager: GameManager
var tile_set: BaseGrid

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(get_parent() is GameManager)
	game_manager = get_parent()
	assert(game_manager.get_parent() is SceneManager)
	scene_manager = game_manager.get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
