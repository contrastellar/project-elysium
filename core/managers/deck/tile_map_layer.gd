extends TileMapLayer
class_name DeckTileMap

enum droppable {droppable = 1, undroppable = 2}

const SIDE_SIZE = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func normalize_point_to_grid(pos: Vector2i) -> Vector2i:
	return pos


func return_global_grid_position(pos: Vector2) -> Vector2:
	pos = normalize_point_to_grid(pos)
	# There's some messy math going on here, but here's the basics
	# 1. We convert the position to local coords on the map
	# 2. We multiply that by the vector that is the length of the two sides (cartesian product)
	# 3. We add the distance of half the cell-size to center it.
	return (Vector2(local_to_map(pos)) * Vector2(SIDE_SIZE, SIDE_SIZE)) + position + Vector2(SIDE_SIZE/2, SIDE_SIZE/2)

func is_droppable(pos: Vector2) -> bool:
	var _pos = normalize_point_to_grid(pos)
	_pos = local_to_map(pos)
	
	print(get_cell_source_id(pos))
	if get_cell_source_id(_pos) == droppable.droppable:
		return true
	
	return false
