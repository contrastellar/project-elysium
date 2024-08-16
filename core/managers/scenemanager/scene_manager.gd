extends Node
class_name SceneManager

@export var first_scene: PackedScene

var _current_scene: PackedScene
var _current_node: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var first_scene_parent_node: Node
	first_scene_parent_node = first_scene.instantiate()
	add_child(first_scene_parent_node)
	set_current_scene(first_scene, first_scene_parent_node)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_current_scene(scene: PackedScene, node: Node) -> void:
	_current_scene = scene
	_current_node = node
	pass

func change_scene(scene: PackedScene) -> void:
	remove_child(_current_node)

	set_current_scene(null, null)

	var scene_node = scene.instantiate()
	add_child(scene_node)
	set_current_scene(scene, scene_node)
	return
