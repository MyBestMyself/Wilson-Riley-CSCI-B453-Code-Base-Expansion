extends Node2D

func _ready():
	get_node("/root/Game").set_screen_camera()
