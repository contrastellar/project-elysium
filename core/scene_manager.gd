extends Node
class_name SceneManager

@export var first_scene: PackedScene

# Base class for the scene manager
# Should be the highest level in the tree
# Should add other scenes beneath it in the tree

var current_scene: PackedScene
var current_scene_node: Node
var game_over_screen: PackedScene # TODO add game_over node to this line
var _game_over_screen_instance: Control
var _show_game_over_screen: bool = false
var _remove_game_over_screen: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var first_scene_node: Node
	first_scene_node = first_scene.instantiate()
	# INFO cannot forget to set the current_scene_node at initialization,
	# otherwise you will get an error trying to move between scenes
	
	current_scene_node = first_scene_node
	
	# add the newly instantiated child to the tree
	add_child(first_scene_node)
	# TODO set current scene to the first_scene_node


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_current_scene(new_scene: PackedScene, new_scene_node: Node) -> void:
	current_scene = new_scene
	current_scene_node = new_scene_node
	return


func change_scene(scene: PackedScene) -> void:
	remove_child(current_scene_node)

	set_current_scene(null, null)

	var scene_node = scene.instantiate()
	add_child(scene_node)
	set_current_scene(scene, scene_node)
	return


func return_to_menu() -> void:
	_remove_game_over_screen = true
	# TODO add main_menu scene here
	change_scene(preload("res://core/main_menu.tscn"))


func show_game_over_screen() -> void:
	add_child(game_over_screen.instantiate())
	_game_over_screen_instance = get_child(get_children().find(GameOverScreen))
	_game_over_screen_instance.set('z_index', 2)
	_show_game_over_screen = true
	return
