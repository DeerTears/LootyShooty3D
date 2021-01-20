extends Spatial

signal shoot

var damage = 10
var automatic_fire: bool = false

func _physics_process(_delta):
	if automatic_fire:
		shoot()

func shoot():
	if $FirerateTimer.is_stopped():
		$FirerateTimer.start()
		emit_signal("shoot",$FirerateTimer.wait_time)
		for i in $Emitters.get_child_count():
			$Emitters.get_child(i).damage = damage
			$Emitters.rotation_degrees = Vector3(rand_range(-10.0,10.0),rand_range(-10.0,10.0),0.0)
			$Emitters.get_child(i).shoot()
