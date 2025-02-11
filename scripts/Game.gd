extends Node2D

var levels = [ "StartScreen", "Level1", "Level1Win", "Level2", "Level2Win", "Level3", "Level3Win" ]
var scenes = { }
var screenCamera

export (int) var current_level = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	screenCamera = get_node("ScreenCamera")
	scenes = {
		"StartScreen" : preload("res://levels/StartScreen.tscn"),
		"Level1" : preload("res://levels/Level1.tscn"),
		"Level1Win" : preload("res://levels/Level1Win.tscn"),
		"Level2" : preload("res://levels/Level2.tscn"),
		"Level2Win" : preload("res://levels/Level2Win.tscn"),
		"Level3" : preload("res://levels/Level3.tscn"),
		"Level3Win" : preload("res://levels/Level3Win.tscn"),
	}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_released("ui_cancel") && current_level != 0:
		unload_level(levels[current_level])
		load_level(levels[0])
		set_screen_camera()
		current_level = 0
	if Input.is_action_just_released("level1") && current_level != 1 && OS.is_debug_build():
		unload_level(levels[current_level])
		load_level(levels[1])
		current_level = 1
	elif Input.is_action_just_released("level2") && current_level != 3 && OS.is_debug_build():
		unload_level(levels[current_level])
		load_level(levels[3])
		current_level = 3
	elif Input.is_action_just_released("level3") && current_level != 5 && OS.is_debug_build():
		unload_level(levels[current_level])
		load_level(levels[5])
		current_level = 5
	elif Input.is_action_just_released("reset"):
		restart_current_level()

func unload_level(name):
	print_debug("unloading " + name)
	var node = get_node_or_null(name)
	if node != null:
		remove_child(node)
		node.queue_free()
		print_debug("unloaded " + name)

func load_level(name):
	print_debug("loading " + name)
	if scenes.has(name):
		var instance = scenes[name].instance()
		add_child(instance)
		print_debug("loaded " + name)
		
func restart_current_level():
	var curname = levels[current_level]
	print_debug("restarting" + curname)
	unload_level(curname)
	load_level(curname)
	
func load_next():
	if current_level < levels.size() - 1:
		var curname = levels[current_level]
		print_debug("loading level after" + curname)
		unload_level(curname)
		load_level(levels[current_level + 1])
		current_level += 1
		
func back_to_start():
	var curname = levels[current_level]
	print_debug("back to start")
	unload_level(curname)
	load_level("StartScreen")
	
func set_screen_camera():
	screenCamera.make_current()
