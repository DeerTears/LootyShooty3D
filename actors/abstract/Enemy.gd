extends Actor

class_name Enemy

func _physics_process(_delta):
	direction = Vector3()
	if is_on_floor():
		gravity_vec.y = 0
	else:
		gravity_vec.y = -9.81
	velocity = direction * speed + (Vector3.ONE * gravity_vec)
	velocity.y = gravity_vec.y
	move_and_slide(velocity)
