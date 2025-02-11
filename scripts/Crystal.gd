extends Area2D

class_name Crystal

func _on_RedCrystal_body_entered(body):
	if body.has_method("collect_crystal"):
		body.collect_crystal(self)
		
func hide_and_reparent(new_parent):
	get_node("Sprite").hide()
	set_deferred("monitorable", false)
	set_deferred("monitoring", false)
	call_deferred("reparent", self, new_parent)

func reparent(child: Node2D, new_parent: Node2D):
	var old_parent = child.get_parent()
	old_parent.remove_child(child)
	new_parent.add_child(child)
	child.position = Vector2(0, 0)
