extends Node2D
class_name BaseEnemy

enum State { IDLE, FOLLOW }

@export var speed: float = 150.0

var _tile_map: TileMapLayer
var _path: PackedVector2Array
var _state: int
var _velocity = Vector2()
var next_point = Vector2()
var _stage: BaseStage

const MASS = 10.0
const ARRIVE_DISTANCE = 5.0

func _ready():
	_tile_map = get_parent()
	assert(_tile_map is TileMapLayer)
	# ATTENTION This one line is super important, you cannot instantiate
	# the enemy node without this, else it breaks
	_change_state(State.FOLLOW)
	return

# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
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
	queue_free()
	return
