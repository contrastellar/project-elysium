extends Node

var scene_manager: SceneManager
var gameplay_scene: PackedScene = preload("res://assets/base_stage/base_stage.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scene_manager = get_parent()
	assert(scene_manager is SceneManager)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_test_scene_pressed() -> void:
	scene_manager.change_scene(gameplay_scene)
	return
