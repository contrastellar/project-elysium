extends Node
class_name SceneManager

@export var first_scene: PackedScene

var _current_node: Node
var _game_manager: GameManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var first_scene_parent_node: Node
	first_scene_parent_node = first_scene.instantiate()
	add_child(first_scene_parent_node)
	set_current_scene(first_scene_parent_node)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func return_to_menu() -> void:
	change_scene(first_scene.instantiate())


func set_current_scene(node: Node) -> void:
	_current_node = node
	pass


func change_scene(scene: Node) -> void:
	remove_child(_current_node)

	set_current_scene(null)

	add_child(scene)
	set_current_scene(scene)
	return


func load_test_scene() -> void:
	_current_node.prepare_game("res://assets/test_stage/test_stage.json")
