extends BasePC

enum type {_placement_grid = 0, _grid = 1}


var draggable: bool = false
var is_inside_droppable: bool = false
var droppable_position: Vector2 # The position (in global coords) of the droppable cell
var offset: Vector2 # The place on the local body of the pc_tile
var initial_pos: Vector2 # The starting place of the pc_tile when an interaction occurs
var place_in_list: Vector2 # The position in the list, determined by a handler?
var _deck: Deck # The grid that we're working off of, should always point to the parent of this node
var _placement_grid: BaseGrid
var _game_manager: GameManager
var cost: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	IsDragging.is_dragging = false
	_deck = get_parent()
	assert(get_parent() is Deck)
	assert(_deck.get_parent() is GameManager)
	_game_manager = _deck.get_parent()
	_placement_grid = _game_manager.stage.tile_set
	
	scale = Vector2(0.15, 0.15)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if draggable:
		if Input.is_action_just_pressed("click"):
			initial_pos = global_position
			offset = get_global_mouse_position() - global_position
			IsDragging.is_dragging = true
			
		if Input.is_action_pressed("click"):
			# INFO removed the offset
			global_position = get_global_mouse_position()
			
		elif Input.is_action_just_released("click"):
			IsDragging.is_dragging = false
			var mouse_pos: Vector2 = get_global_mouse_position()
			var _placement_grid_inside_droppable: bool = _placement_grid.is_melee_droppable(mouse_pos)
			var _grid_is_droppable: bool = _deck.is_droppable(mouse_pos)
			
			is_inside_droppable = _placement_grid_inside_droppable or _grid_is_droppable
			print("Droppable on deck? -- " + str(_grid_is_droppable))
			print("Droppable on stage? -- " + str(_placement_grid_inside_droppable))
			
			var _type_of_droppable: int
			if is_inside_droppable and _placement_grid_inside_droppable:
				_type_of_droppable = type._placement_grid
				print("Is stage")
				
			elif is_inside_droppable and _grid_is_droppable:
				_type_of_droppable = type._grid
				print("Is deck")
				
			
			var tween = get_tree().create_tween()
			
			if _placement_grid.is_tile_open(_deck.tile_map.local_to_map(mouse_pos)):
				if is_inside_droppable and _type_of_droppable == type._grid:
					droppable_position = _deck.return_global_grid_position(mouse_pos)
					_placement_grid.set_tile_closed(_deck.tile_map.local_to_map(mouse_pos))
					tween.tween_property(self, "global_position", droppable_position, 0.1).set_ease(Tween.EASE_OUT)
					
				elif is_inside_droppable and _type_of_droppable == type._placement_grid:
					droppable_position = _placement_grid.return_global_grid_position(mouse_pos)
					_placement_grid.set_tile_open(_deck.tile_map.local_to_map(initial_pos))
					tween.tween_property(
						self, "global_position", 
						droppable_position, 0.1
						).set_ease(Tween.EASE_OUT)
				
				else:
					tween.tween_property(self, "global_position", initial_pos, 0.1).set_ease(Tween.EASE_OUT)
			
			

func reset_draggable():
	if not IsDragging.is_dragging:
		IsDragging.is_dragging = false
		draggable = false
		scale = Vector2(0.15, 0.15)


# Function that runs when the mouse enters the tile
func _on_area_2d_mouse_entered():
	if not IsDragging.is_dragging:
		draggable = true
		scale = Vector2(0.16, 0.16)


# Function that runs when the mouse exits the tile
func _on_area_2d_mouse_exited():
	reset_draggable()
