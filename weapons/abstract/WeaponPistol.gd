extends Weapon

func _ready():
	update_firerate(0.5)

func shoot():
	if firerate_timer.is_stopped():
		for i in get_child_count():
			get_child(i).shoot()
			firerate_timer.start()
