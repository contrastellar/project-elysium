extends Node2D
class_name BaseStage

var scene_manager: SceneManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(get_parent() is SceneManager)
	scene_manager = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_menu_return_pressed() -> void:
	print('returning to menu')
	scene_manager.return_to_menu()
