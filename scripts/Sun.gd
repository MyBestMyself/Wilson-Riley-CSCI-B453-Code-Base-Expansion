extends KinematicBody2D

class_name Sun

export (int) var mass = 1000

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Gravity_Well_body_entered(body):
	if body.has_method("register_gravity_well"):
		body.register_gravity_well(self)

func _on_Gravity_Well_body_exited(body):
	if body.has_method("unregister_gravity_well"):
		body.unregister_gravity_well(self)
