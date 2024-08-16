extends Node
class_name GameManager

signal game_over
signal game_prepared

@export var test_enemy: PackedScene

var scene_manager: SceneManager
var stage_scene: PackedScene
var stage: BaseStage
var _arena: TileMapLayer # Will be the playable_grid
var _deck: TileMapLayer # Will be where ANGELs are "stored"

var stage_id: String

# Stats for the mission
# Set these in initally to 0, to be updated later
var life_total: int = 3			# The number of health points available to lose
var enemy_total: int = 0		# Should be the number of enemies spawned
var enemies_spawned: int = 0 	# Useful for game management later on

var mission_uid: String
var mission_parameters: Dictionary
var mission_parameters_path: String
var mission_path: String

# Arrays to store information from the JSON mission loader
var _enemy_scenes: Dictionary
var _enemy_spawn_points: Dictionary
var _protection_objs: Dictionary
var _enemy_spawn_point_count: int
var _protection_obj_count: int
var _melee_tile_count: int
var _ranged_tile_count: int

# PC related variables
var _pc_count: int
var _pc_types: Array = Array()

var _is_setup: bool = false

var __game_over_sent: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scene_manager = get_parent()
	assert(scene_manager is SceneManager)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if life_total == 0 && not __game_over_sent:
		# At this point, the `game over` screen should play
		send_game_over()


func send_game_over() -> void:
	if not __game_over_sent:
		game_over.emit()
		__game_over_sent = true
		print("Emitting!")
	return


# Called when the game manager has been loaded with the correct instance
# Variables
func prepare_game(new_mission_path: String) -> void:
	assert(mission_parameters_path != null, "Param path is null!")
	assert(stage_id != null, "stage_id is null!")
	# This should prevent duplicate calls
	if not _is_setup:
		mission_parameters_path = new_mission_path
		load_mission_parameters()
		_is_setup = true
	
	if mission_uid == "T":
		stage_scene = preload("res://assets/test_stage/test_stage.tscn")
	
	assert(stage_scene != null, "No stage found!")
	
	stage = stage_scene.instantiate()
	add_child(stage)
	stage.set_stage_id(mission_uid)
	_arena = stage.find_child("TileMap")


func set_mission_param_path(path: String) -> String:
	mission_parameters_path = path
	return mission_parameters_path

func load_mission_parameters() -> void:
	# Grab the file and access it
	var file_opened = FileAccess.open(mission_parameters_path, FileAccess.READ)
	mission_parameters = JSON.parse_string(file_opened.get_as_text())
	
	#Load values from the JSON file
	# Load UID, Path, Enemy Total and Life Total
	mission_uid = mission_parameters["mission_uid"][0]
	mission_path = mission_parameters["mission_path"]
	enemy_total = mission_parameters["enemy_count"]
	life_total = mission_parameters["life_total"]
	
	# Handle private variables
	_enemy_spawn_points = mission_parameters["enemy_spawns"]
	_protection_objs = mission_parameters["obj"]
	_enemy_spawn_point_count = mission_parameters["enemy_spawns"]["count"]
	_protection_obj_count = mission_parameters["obj"]["count"]
	_melee_tile_count = mission_parameters["deployable_melee"]["count"]
	_ranged_tile_count = mission_parameters["deployable_ranged"]["count"]
	
	# Handle PC variables
	_pc_count = mission_parameters["pcs"]["count"]
	for i in _pc_count:
		_pc_types.append(mission_parameters["pcs"][str(i)])
	
	return


func set_life_total(total) -> int:
	life_total = total
	return life_total 


func set_enemy_max_total(total: int) -> int:
	enemy_total = total
	return enemy_total


func set_enemy_active_total(total: int) -> int:
	enemies_spawned = total
	return enemies_spawned


func get_pc_data(idx: int) -> String:
	return _pc_types[idx]


func get_tile_set() -> TileSet:
	var output: TileSet
	
	if mission_uid == "T":
		output = preload("res://assets/test_stage/test_tile_set.tres")
	
	return output


# Returns the coordinates (in the tile-map-coordinates) of a specific spawn coordinates
func return_spawn_coords(id: int) -> Vector2i:
	var x_coord = var_to_str(id)
	var y_coord = var_to_str(id)
	x_coord += "_x"
	y_coord += "_y"
	var vector = Vector2i(_enemy_spawn_points[x_coord], _enemy_spawn_points[y_coord])
	return _arena.return_grid_position(vector)


# Returns the coordinates (in tile-map-coordinates) of a specific protection objective
func return_obj_coords(id: int) -> Vector2i:
	var x_coord = var_to_str(id)
	var y_coord = var_to_str(id)
	x_coord += "_x"
	y_coord += "_y"
	var vector = Vector2i(_protection_objs[x_coord], _protection_objs[y_coord])
	return _arena.return_grid_position(vector)


func _on_spawn_enemy_pressed() -> void:
	if enemies_spawned < enemy_total:
		var enemy = test_enemy.instantiate()
		enemy.position = return_spawn_coords(0)
		enemy.next_point = return_obj_coords(0)
		
		_arena.add_child(enemy)
		
		enemies_spawned = enemies_spawned + 1


func _on_return_to_menu_pressed() -> void:
	scene_manager.return_to_menu()
