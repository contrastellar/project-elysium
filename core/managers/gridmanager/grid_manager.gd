extends Node
class_name GridManager

var arena_grid: BaseGrid
var pc_manager: PCManager

# The manager for the player grid and the pc 'deck'

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(get_node("BaseGrid") is BaseGrid)
	assert(get_node("PcManager") is PCManager)
	arena_grid = get_node("BaseGrid")
	pc_manager = get_node("PcManager")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_tile_set(_ts: TileSet) -> bool:
	arena_grid.tile_set = _ts
	return true
