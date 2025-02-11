extends KinematicBody2D

class_name Planet

onready var path_follow = get_parent()

export (int) var mass = 200
export (float) var orb_period = 20
export (float) var day_length = 6

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	rotation += 2 * PI * delta / day_length
	path_follow.set_unit_offset(path_follow.get_unit_offset() + delta / orb_period)

func _on_Gravity_Well_body_entered(body):
	if body.has_method("register_gravity_well"):
		body.register_gravity_well(self)

func _on_Gravity_Well_body_exited(body):
	if body.has_method("unregister_gravity_well"):
		body.unregister_gravity_well(self)
