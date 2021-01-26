extends Spatial
class_name WeaponSlot

# WeaponSlot contains a Weapon, and a gun_resource.
# WeaponSlots pass their gun_resource parameters to the sole Weapon child they're responsible for.
# This Weapon can then be fired through this WeaponSlot's "shoot" method.

export (Resource) var gun_resource = load("res://weapons/saved/inventory_placeholder.tres")
var guntype

onready var weapon = $Weapon

func _ready():
	if gun_resource != null:
		set_gun_resource(gun_resource)

func shoot():
	weapon.shoot()

# setter, getter, swap and clear for gun_resource

func set_gun_resource(new_gun:Resource):
	gun_resource = new_gun
	guntype = gun_resource.guntype
	# bug: update_pellet_count NEEDS to be called first, otherwise emitter damage, range, and accuracy aren't applied
	weapon.update_pellet_count(gun_resource.pellet_count)
	weapon.update_damage(gun_resource.damage)
	weapon.update_accuracy(gun_resource.accuracy)
	weapon.update_firerate(gun_resource.firerate)
	weapon.update_bullet_range(gun_resource.bullet_range)
	weapon.update_swap_time(gun_resource.swap_time)

func get_gun_resource() -> Resource:
	return gun_resource

func clear_gun_resource():
	gun_resource = load("res://weapons/saved/inventory_placeholder.tres")

#func swap_gun_resource(new_gun:Resource): # might not work, don't touch for a bit
#	var return_gun = gun_resource
#	gun_resource = new_gun
#	return return_gun
