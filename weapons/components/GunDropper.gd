extends Spatial

var direction = Vector3()

func drop_random_gun():
	var new_gun = load("res://weapons/components/ItemBody.tscn").instance()
	new_gun.global_transform = self.global_transform
	new_gun.drop_trajectory = direction
	new_gun.gun_resource = load(meta.gunlist[randi() % meta.gunlist.size() - 1])
	get_tree().root.add_child(new_gun)

func drop_gun(_guntype:int,_rarity:float):
	var new_gun = load("res://weapons/components/ItemBody.tscn").instance()
	new_gun.global_transform = self.global_transform
	new_gun.drop_trajectory = -transform.basis.z
	new_gun.gun_resource = gun.new()	
	get_tree().root.add_child(new_gun)
