extends Node2D

onready var on_indicators = get_node("On").get_children()

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in on_indicators:
		i.hide()

func _on_Raumschiff_crystal_collected(new_count):
	for i in range(0, new_count):
		on_indicators[i].show()
