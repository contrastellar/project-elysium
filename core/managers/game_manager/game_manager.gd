# game_manager is a child of a stage

extends Node
class_name GameManager

signal game_over

var grid_manager: GridManager
var arena: BaseStage # Should be the parent
var playable_grid: BaseGrid
var pc_manager: PCManager


var _is_setup: bool

# enemy_scene to be used as a placeholder instead of a more
# 'proper' enemy type
var enemy_scene: PackedScene = preload("res://assets/enemies/test/test_enemy.tscn")

# Stats for the mission
# Set these in initally to 0, to be updated later
var life_total: int = 0			# The number of health points available to lose
var enemy_total: int = 0		# Should be the number of enemies spawned
var enemies_spawned: int = 0 	# Useful for game management later on

# Mission parameters
var mission_uid: String = ""	# Useful in referencing the mission internally
var mission_parameters 			# The type here is irrelevant (I think its a dict)
var mission_parameters_path: String
var mission_path: String 		# in case we get lost?

# Arrays to store tile information based on UID
# (distance from the origin determines UID in theory)
var _enemy_spawn_points: Dictionary
var _protection_objectives: Dictionary
var _enemy_spawn_point_count: int
var _protection_objectives_count: int
var _melee_tile_count: int
var _ranged_tile_count: int

# PC related variables
var _pc_count: int
var pc_types: Array = Array()

# Signal processing
var __game_over_sent: bool



# Called when the node enters the scene tree for the first time.
func _ready():
	assert(get_parent() is BaseStage)
	arena = get_parent()
	grid_manager = arena.get_node('./GridManager')
	assert(grid_manager is GridManager)
	playable_grid = grid_manager.arena_grid
	pc_manager = grid_manager.pc_manager
	assert(playable_grid is BaseGrid)
	assert(pc_manager is PCManager)

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta):
	if life_total == 0 && not __game_over_sent:
		# At this point, the `game over` screen should play
		send_game_over()
	
	pass

func send_game_over() -> void:
	if not __game_over_sent:
		game_over.emit()
		__game_over_sent = true
		print("Emitting!")
	return

func set_mission_parameters_path(path: String) -> String:
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
	_protection_objectives = mission_parameters["obj"]
	_enemy_spawn_point_count = mission_parameters["enemy_spawns"]["count"]
	_protection_objectives_count = mission_parameters["obj"]["count"]
	_melee_tile_count = mission_parameters["deployable_melee"]["count"]
	_ranged_tile_count = mission_parameters["deployable_ranged"]["count"]
	
	# Handle PC variables
	_pc_count = mission_parameters["pcs"]["count"]
	for i in _pc_count:
		pc_types.append(mission_parameters["pcs"][str(i)])
	
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
	return pc_types[idx]

# This function serves as a single-call usage of loading a particular stage's information
func load_game_values(new_mission_path: String) -> void:
	# This should prevent duplicate calls
	if not _is_setup:
		mission_parameters_path = new_mission_path
		load_mission_parameters()
		_is_setup = true
	return


# Returns the coordinates (in the tile-map-coordinates) of a specific spawn coordinates
func return_spawn_coords(id: int) -> Vector2i:
	var x_coord = var_to_str(id)
	var y_coord = var_to_str(id)
	x_coord += "_x"
	y_coord += "_y"
	var vector = Vector2i(_enemy_spawn_points[x_coord], _enemy_spawn_points[y_coord])
	return playable_grid.return_grid_position(vector)


# Returns the coordinates (in tile-map-coordinates) of a specific protection objective
func return_obj_coords(id: int) -> Vector2i:
	var x_coord = var_to_str(id)
	var y_coord = var_to_str(id)
	x_coord += "_x"
	y_coord += "_y"
	var vector = Vector2i(_protection_objectives[x_coord], _protection_objectives[y_coord])
	return playable_grid.return_grid_position(vector)


func get_tile_set() -> TileSet:
	var output: TileSet
	
	if mission_uid == "T":
		output = preload('res://assets/stages/base_stage/test_grid.tres')
	
	
	return output


# Spawn an enemy
func spawn_enemy(spawn_id: int, obj_target: int) -> void:
	# Need to get the coordinates for the spawner_id (does this need to be 
	# grid coords?) and then spawn a child enemy there.
	if enemies_spawned < enemy_total:
		# FIXME need to fix this when i get the grid system working again
		var enemy = enemy_scene.instantiate()
		enemy.position = return_spawn_coords(spawn_id)
		enemy.next_point = return_obj_coords(obj_target)
		# Add this newly instantiated Node as a child of the Arena scene
		arena.grid_manager.arena_grid.add_child(enemy)
		enemies_spawned = enemies_spawned + 1
		arena.set_active_count(enemies_spawned)
	
	return
