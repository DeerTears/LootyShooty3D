extends Weapon

func _ready():
	update_firerate(1.0)
	update_pellet_count(11)

func shoot():
	for i in get_child_count():
		get_child(i).shoot()
