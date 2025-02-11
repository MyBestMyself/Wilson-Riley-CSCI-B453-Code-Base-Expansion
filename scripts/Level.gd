extends Node2D

export (int) var crystal_count = 3

func _on_Raumschiff_crystal_collected(new_count):
	if new_count >= crystal_count:
		get_node("Raumschiff").win()
