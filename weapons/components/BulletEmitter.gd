extends Spatial

onready var ray = $RayCast

var damage: int = 1

func shoot():
	$Particles.emitting = true
	if ray.is_colliding():
		var target = ray.get_collider()
		if target.is_in_group("Enemy"):
			print("hit %s" % [target])
			target.hurt(damage)
