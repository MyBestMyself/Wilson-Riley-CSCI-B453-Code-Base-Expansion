extends Button

func _button_pressed():
	var game = get_node("/root/Game")
	game.load_next()
