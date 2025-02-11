extends Button

func _ready():
	get_tree().paused = true

func _button_pressed():
	get_parent().visible = false
	get_tree().paused = false
