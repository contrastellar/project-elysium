extends Node
class_name SceneManager

enum loading_screen_state {off = 0, show = 1}

@export var first_scene: PackedScene
@export var loading_screen: PackedScene

var show_loading_screen: int

var _current_scene: PackedScene
var _current_node: Node
var loading_screen_inst: LoadingScreen

const opacity_change: float = 0.0075


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	loading_screen_inst = loading_screen.instantiate()
	# loading_screen_inst.modulate.a = 0
	add_child(loading_screen_inst)
	
	show_loading_screen = loading_screen_state.show
	
	set_current_scene(first_scene, true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_loading_screen_process()
	pass

# bypass is a variable that enables the loading screen to be bypassed, by default it is "false"
func set_current_scene(scene: PackedScene, bypass: bool = false) -> void:
	# If bypass is set to "false"
	if not bypass:
		change_scene()
		_current_node.queue_free()
		
		var scene_node = scene.instantiate()
		add_child(scene_node)
		
		_current_scene = scene
		_current_node = scene_node
		
		remove_loading_screen()
		
	else:
		var scene_node = scene.instantiate()
		_current_scene = scene
		_current_node = scene_node
		add_child(scene_node)
		remove_loading_screen()
		
	return

func remove_loading_screen() -> void:
	show_loading_screen = loading_screen_state.off

func change_scene() -> void:
	show_loading_screen = loading_screen_state.show


func _loading_screen_process() -> void:
	if show_loading_screen == loading_screen_state.off:
		if loading_screen_inst.modulate.a >= 0:
			loading_screen_inst.modulate.a -= opacity_change
			
	elif show_loading_screen == loading_screen_state.show:
		if loading_screen_inst.modulate.a <= 1:
			loading_screen_inst.modulate.a += opacity_change
	
	return
