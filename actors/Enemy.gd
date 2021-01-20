extends KinematicBody

var health = 1
var max_health = 100
var velocity = Vector3()

func hurt(damage:int):
	health -= damage
	$Particles/Spill.emitting = true
	$Particles/ImpactX.emitting = true
	$Particles/ImpactZ.emitting = true
	print("we're hit!")
	if health <= 0:
		die()
		$GunDropper.drop_random_gun()
#		var new_gun = load("res://actors/components/item_body.tscn").instance()
#		new_gun.global_transform = self.global_transform
#		new_gun.drop_trajectory = -transform.basis.z
#		new_gun.gun_resource = load(meta.gunlist[randi() % meta.gunlist.size() - 1])
#		get_tree().root.add_child(new_gun)

func die():
	queue_free()

func _physics_process(_delta):
	if is_on_floor():
		velocity.y = -9.81
	else:
		velocity.y = 0
	move_and_slide(velocity)
