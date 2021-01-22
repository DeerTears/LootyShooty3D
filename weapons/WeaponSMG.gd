extends Weapon

func _ready():
	update_firerate(0.2)

func shoot():
	for i in get_child_count():
		get_child(i).shoot()
