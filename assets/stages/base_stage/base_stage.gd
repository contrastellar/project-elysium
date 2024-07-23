extends Node2D
class_name BaseStage

signal game_end
signal game_over

var scene_manager: SceneManager
var game_manager: GameManager
var grid_manager: GridManager
var gui_elements: Control

var max_enemies: int = 0
var enemy_count: int = 0
var life_count: int = 0

var grid_position: Vector2i = Vector2i(0, 0)
var grid_manager_pos: Vector2 = Vector2(230, 60)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(get_parent() is SceneManager)
	scene_manager = get_parent()
	
	assert(get_node("gui_elements") is Control)
	gui_elements = get_node("gui_elements")
	
	assert(get_node("GameManager") is GameManager)
	game_manager = get_node("GameManager")
	
	assert(get_node('GridManager') is GridManager)
	grid_manager = get_node('GridManager')
	
	game_manager.load_game_values('res://assets/stages/base_stage/base_stage_info.json')

	# connect the game_over from the game_manager to the base_stage, giving a
	# throughline to the scenemanager
	game_manager.game_over.connect(report_game_over)

	game_over.connect(scene_manager.show_game_over_screen)
	
	load_tile_set()
	
	set_life_total(game_manager.life_total)
	set_total_count(game_manager.enemy_total)
	
	grid_manager.position = grid_manager_pos
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	enemy_count = game_manager.enemies_spawned
	$gui_elements/enemy_total.text = 'TOTAL = ' + str(game_manager.enemy_total)
	$gui_elements/enemy_count.text = 'ENEMIES = ' + str(game_manager.enemies_spawned)
	$gui_elements/life.text = 'LIFE = ' + str(game_manager.life_total)


func _on_return_home_pressed() -> void:
	scene_manager.return_to_menu()


func _on_spawn_enemy_pressed():
	game_manager.spawn_enemy(0, 2)
	return


func load_tile_set() -> void:
	var _tile_set: TileSet = game_manager.get_tile_set()
	assert(_tile_set is TileSet)

	var _is_set: bool = grid_manager.arena_grid.set_tile_set(_tile_set)
	var __pattern = grid_manager.arena_grid.tile_set.get_pattern(1)
	grid_manager.arena_grid.set_pattern(0, grid_position, __pattern)
	grid_manager.arena_grid.update_tiles()
	assert(_is_set is bool)
	return


func report_game_over() -> void:
	game_over.emit()
	return

func set_life_total(count: int) -> void:
	game_manager.life_total = count
	return


func set_active_count(count: int) -> void:
	game_manager.enemy_total = count
	return

func set_total_count(count: int) -> void:
	max_enemies = count
	return
