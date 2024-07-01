extends Node2D
class_name MainMenu

var scene_manager: SceneManager


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(get_parent() is SceneManager, 'parent is not scene manager!')
	scene_manager = get_parent()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	print('moving to gameplay demo screen!')
	scene_manager.change_scene(preload('res://assets/stages/base_stage/base_stage.tscn'))
	pass # Replace with function body.
