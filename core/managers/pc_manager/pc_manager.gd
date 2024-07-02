extends Node2D
class_name PCManager

var pc_deck: PCDeck

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(get_node('Deck') is PCDeck)
	pc_deck = get_node('Deck')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
