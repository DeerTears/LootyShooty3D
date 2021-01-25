extends KinematicBody

class_name Actor

var health = 100
var max_health = 100

var speed = 15

var velocity = Vector3()
var direction = Vector3()
var gravity_vec = Vector3()

func hurt(damage:int):
	health -= damage
	print("%s got hit for %s!" % [name, damage])
	_hurt()
	if health <= 0:
		die()

func _hurt():
	pass

func die():
	queue_free()
