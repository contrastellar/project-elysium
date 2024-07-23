extends Node
class_name SceneManager

@export var first_scene: PackedScene

# Base class for the scene manager
# Should be the highest level in the tree
# Should add other scenes beneath it in the tree

var current_scene: PackedScene
var current_scene_node: Node
var game_over_screen: PackedScene = preload("res://core/game_over.tscn")
var _game_over_screen_instance: Control
var _show_game_over_screen: bool = false
var _remove_game_over_screen: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var first_scene_node: Node
	first_scene_node = first_scene.instantiate()
	# INFO cannot forget to set the current_scene_node at initialization,
	# otherwise you will get an error trying to move between scenes
	
	set_current_scene(first_scene, first_scene_node)
	
	# add the newly instantiated child to the tree
	add_child(first_scene_node)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _show_game_over_screen && not _remove_game_over_screen && _game_over_screen_instance:
		_game_over_screen_instance.modulate.a += 0.01
		var screen_alpha = _game_over_screen_instance.modulate.a
		if screen_alpha >= 1:
			_show_game_over_screen = false

	elif _remove_game_over_screen && _game_over_screen_instance:
		_show_game_over_screen = false
		_game_over_screen_instance.modulate.a -= 0.01
		var screen_alpha = _game_over_screen_instance.modulate.a
		if screen_alpha < 0.01:
			_game_over_screen_instance.modulate.a = 0
			_game_over_screen_instance.queue_free()
			_remove_game_over_screen = false


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
	var __game_over_instance = game_over_screen.instantiate()
	add_child(__game_over_instance)
	_game_over_screen_instance = __game_over_instance
	_game_over_screen_instance.modulate.a = 0
	_show_game_over_screen = true
	return
