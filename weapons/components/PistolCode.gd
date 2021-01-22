extends Spatial

signal shoot

var damage = 10
var accuracy = 90.0
var automatic_fire: bool = false

func _physics_process(_delta):
	if automatic_fire:
		shoot()

func shoot():
	if $FirerateTimer.is_stopped():
		$FirerateTimer.start()
		emit_signal("shoot",$FirerateTimer.wait_time)
		var inaccuracy = 100.0 - accuracy
		for i in $Emitters.get_child_count():
			$Emitters.get_child(i).damage = damage
			$Emitters.rotation_degrees = Vector3(rand_range(-inaccuracy,inaccuracy),rand_range(inaccuracy,inaccuracy),0.0)
			$Emitters.get_child(i).shoot()
