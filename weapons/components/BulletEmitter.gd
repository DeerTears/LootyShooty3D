extends Spatial
# a class that provides raycasts and tracers for guns

onready var ray = $RayCast

var damage: int = 1 # updated by the "update_damage" function in Weapon.gd or a WeaponClass that extends Weapon.gd
export(float, 0.0, 1.0, 0.001) var accuracy = 0.95 # 1 == max accuracy, also updated by the "update_accuracy" function in Weapon.gd or a WeaponClass

func _ready():
	$Tracer.hide()

func shoot():
	var inaccuracy = rand_range(-1.0,1.0)
	rotation = Vector3.ZERO
	rotate(Vector3.UP,(deg2rad(45) * inaccuracy * (1.0 - accuracy)))
	if ray.is_colliding():
		var target = ray.get_collider()
		if target.is_in_group("Enemy"):
			print("hit %s" % [target])
			target.hurt(damage)
	$Particles.emitting = true
	$Tracer.show()
	yield(get_tree().create_timer(0.1),"timeout")
	$Tracer.hide()
