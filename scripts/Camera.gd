extends Camera2D

var gameCamera

func _ready():
	gameCamera = get_node("/root/Game/GameCamera")
	make_current()

func _process(_delta):
	if Input.is_action_just_pressed("togglezoom") && current:
		gameCamera.make_current()
	elif Input.is_action_just_released("togglezoom") && !current:
		make_current()
