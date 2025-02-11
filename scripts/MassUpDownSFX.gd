extends AudioStreamPlayer2D

onready var ship = get_parent()
onready var prev_mass = get_parent().m_mass

var stream_mass_up : AudioStream
var stream_mass_down : AudioStream

# Called when the node enters the scene tree for the first time.
func _ready():
	stream_mass_up = preload("res://sound/sfx/GraviAccelerate.mp3")
	stream_mass_down = preload("res://sound/sfx/GraviBreak.mp3")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if prev_mass < ship.m_mass:
		play_mass_up()
	elif prev_mass > ship.m_mass: #and not playing
		play_mass_down()
	prev_mass = ship.m_mass

func play_mass_up():
	stream = stream_mass_up
	play()

func play_mass_down():
	stream = stream_mass_down
	play()
