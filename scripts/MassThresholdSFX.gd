extends AudioStreamPlayer2D

var ship
var prev_mass_range
var range_stream

# Called when the node enters the scene tree for the first time.
func _ready():
	ship = get_parent()
	print_debug(ship.m_mass)
	prev_mass_range = get_current_mass_range()
	print_debug(prev_mass_range)
	
	range_stream = {
		'neg3' : preload("res://sound/sfx/GraviDown3.mp3"),
		'neg2' : preload("res://sound/sfx/GraviDown2.mp3"),
		'neg1' : preload("res://sound/sfx/GraviDown1.mp3"),
		'pos1' : preload("res://sound/sfx/GraviUp1.mp3"),
		'pos2' : preload("res://sound/sfx/GraviUp2.mp3"),
		'pos3' : preload("res://sound/sfx/GraviUp3.mp3"),
	}

func get_current_mass_range():
	var mass = ship.m_mass
	if mass < -50:
		return 'neg3'
	if mass < -20:
		return 'neg2'
	if mass < 0:
		return 'neg1'
	if mass == 0:
		return 'zero'
	if mass < 21:
		return 'pos1'
	if mass < 51:
		return 'pos2'
	return 'pos3'

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var cur_range = get_current_mass_range()
	if cur_range != prev_mass_range:
		if(range_stream.has(cur_range)):
			stream = range_stream[cur_range]
			play()
		prev_mass_range = cur_range
