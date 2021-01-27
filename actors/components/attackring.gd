extends Spatial

signal hurt_with_shockwave

onready var active_ring = $Attack_Active
onready var safety_ring = $Attack_Safety

var in_safety: bool = false
var in_active: bool = false
var current_body

func _on_active_body_entered(body):
	print("active entered %s" % [body])
	pass # Replace with function body.

func _on_active_body_exited(body):
	print("active exited %s" % [body])
	pass # Replace with function body.


func _on_safety_body_entered(body):
	print("safety entered %s" % [body])
	pass # Replace with function body.


func _on_safety_body_exited(body):
	print("safety left %s" % [body])
	pass # Replace with function body.

func check_both_colliders():
	if in_active == false:
		return
	if in_active and in_safety:
		return
	if in_active:
		emit_signal("hurt_with_shockwave")
