extends Node2D
class_name EnemyTest

enum State { IDLE, FOLLOW }

@export var speed: float = 150.0

var _tile_map: BaseGrid
var _path: PackedVector2Array
var _state: int
var _velocity = Vector2()
var next_point = Vector2()
var _game_manager: GameManager
var _stage: BaseStage
var _scene_manager: SceneManager
var _grid_manager: GridManager

const MASS = 10.0
const ARRIVE_DISTANCE = 5.0

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(get_parent() is BaseGrid)
	_tile_map = get_parent()
	_grid_manager = _tile_map.get_parent()
	assert(_grid_manager is GridManager)
	_stage = _grid_manager.get_parent()
	assert(_stage is BaseStage)
	_scene_manager = _stage.get_parent()
	assert(_scene_manager is SceneManager)
	_game_manager = _stage.get_node('./GameManager')
	
	_change_state(State.FOLLOW)


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta):
	if _state != State.FOLLOW:
		return
		
	var arrived_to_next_point = _move_to(next_point)
	if arrived_to_next_point:
		_path.remove_at(0)
		if _path.is_empty():
			_change_state(State.IDLE)
			remove_self()
			return
		next_point = _path[0]


func _move_to(local_position) -> bool:
	var desired_velocity = (local_position - position).normalized() * speed
	var steering = desired_velocity - _velocity
	_velocity += steering / MASS
	position += _velocity * get_process_delta_time()
	# Returns a boolean
	return position.distance_to(local_position) < ARRIVE_DISTANCE


func _change_state(new_state):
	if new_state == State.IDLE:
		_tile_map.clear_path()
		
	elif new_state == State.FOLLOW:
		_path = _tile_map.find_path(position, next_point)
		if _path.size() < 2:
			_change_state(State.IDLE)
			return
		# The index 0 is the starting cell.
		next_point = _path[1]
	
	_state = new_state


func remove_self() -> void:
	_game_manager.set_life_total(_game_manager.life_total - 1)
	_stage.life_count -= 1
	queue_free()
	return
