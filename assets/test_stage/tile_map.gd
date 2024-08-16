extends TileMapLayer
class_name BaseGrid

enum tiles {melee = 2, meteor = 0, enemy_spawn = 3, elysium = 4, ranged = 6}

const SIDE_SIZE = 64

const CELL_SIZE = Vector2i(SIDE_SIZE, SIDE_SIZE)

var start_point = Vector2i()
var end_point = Vector2i()
var _astar = AStarGrid2D.new()
var _path: PackedVector2Array
var _start_point: Vector2i
var _end_point: Vector2i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_astar.region = Rect2i(0, 0, 17, 9)
	_astar.cell_size = CELL_SIZE
	_astar.offset = CELL_SIZE * 0.5
	
	# define the compute and estimate
	_astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	
	_astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	
	_astar.update()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func normalize_point_to_grid(pos: Vector2i) -> Vector2i:
	return pos - Vector2i(position)


func return_grid_position(pos: Vector2) -> Vector2:
	push_warning("return_grid_position() was invoked, this is used for the first and final positions")
	return _astar.get_point_position(pos)


func return_global_grid_position(pos: Vector2) -> Vector2:
	pos = normalize_point_to_grid(pos)
	# There's some messy math going on here, but here's the basics
	# 1. We convert the position to local coords on the map
	# 2. We multiply that by the vector that is the length of the two sides (cartesian product)
	# 3. We add the distance of half the cell-size to center it.
	return (Vector2(local_to_map(pos)) * Vector2(SIDE_SIZE, SIDE_SIZE)) + position + Vector2(SIDE_SIZE/2, SIDE_SIZE/2)


func is_point_walkable(local_position):
	var map_position = local_to_map(local_position)
	
	if _astar.is_in_boundsv(map_position):
		return not _astar.is_point_solid(map_position)
	return false

# clear the path 
func clear_path():
	if not _path.is_empty():
		_path.clear()


func find_path(local_start_point, local_end_point):
	# Clear path, should already exist
	clear_path()
	
	_start_point = local_to_map(local_start_point)
	_end_point = local_to_map(local_end_point)
	_path = _astar.get_point_path(_start_point, _end_point)

	return _path.duplicate()


# Function that returns a bool that dictates whether or not 
# a position is "droppable" for melee characters
func is_melee_droppable(pos: Vector2i) -> bool:
	# Normalize the point to the grid (accounting for 
	# the displacement of the grid on the canvas)
	var _pos = normalize_point_to_grid(pos)
	# Get those coordinates in map coords ie. (7, 4)
	_pos = local_to_map(_pos)
	# Compare the ID to the enum, return true if true
	if get_cell_source_id(_pos) == tiles.melee:
		return true
	
	return false


func is_ranged_droppable(pos: Vector2i) -> bool:
	# Normalize the point to the grid
	var _pos = normalize_point_to_grid(pos)
	# Get the coordinates in map coords
	_pos = local_to_map(_pos)
	# Compare the ID to assure that it's a ranged tile
	if get_cell_source_id(_pos) == tiles.ranged:
		return true
	
	return false


func update_tiles() -> void:
	for i in range(0, _astar.region.end.x):
		for j in range(0, _astar.region.end.y):
			var pos = Vector2i(i, j)
			if get_cell_source_id(pos) == tiles.meteor:
				_astar.set_point_solid(pos)
