extends Spatial
# a class that provides raycasts and tracers for guns

onready var ray = $RayCast

var damage: int = 1 # updated by the "update_damage" function in Weapon.gd or a WeaponClass that extends Weapon.gd
export(float, 0.0, 1.0, 0.001) var accuracy = 0.95 # 1 == max accuracy, also updated by the "update_accuracy" function in Weapon.gd or a WeaponClass

func _ready():
	$Tracer.hide()

# todo: put accuracy calculation in its own function
# todo: make accuracy change the projected "cast_to" of the BulletEmitter, not the spatial rotation

func shoot():
	var inaccuracy = rand_range(-1.0,1.0)
	rotation = Vector3.ZERO
	rotate(Vector3.UP,(deg2rad(45) * inaccuracy * (1.0 - accuracy)))
	if ray.is_colliding():
		var target = ray.get_collider()
		if target.is_in_group("Enemy"):
#			print("hit %s" % [target])
			target.hurt(damage)
	$Particles.emitting = true
	$Tracer.show()
	$Timer.stop()
	$Timer.start()

func _on_Timer_timeout():
	$Tracer.hide()
