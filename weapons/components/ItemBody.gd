extends RigidBody

export (Resource) var gun_resource

var trail_color: Color = Color.black
var collision_size: Vector3
var drop_trajectory = Vector3.UP
var downtime_active: bool = false

func _ready():
	set_downtime_active(true)
	drop_facing(drop_trajectory)
	check_gun_resource()

func set_downtime_active(_true:bool):
	downtime_active = _true
	if _true:
		$ReselectDowntime.start()

func _on_ReselectDowntime_timeout():
	set_downtime_active(false)

func check_gun_resource():
	if gun_resource == null:
		print_debug("error: gun resource not found!")
	else:
		trail_color = meta.rarity_colors[gun_resource.rarity]
		collision_size = meta.guntype_collision_size[gun_resource.guntype]
		if gun_resource.guntype != meta.guntype.KIT:
			$Mesh/DefaultMesh.queue_free()
			var new_mesh = load(meta.guntype_mesh_path[gun_resource.guntype])
			$Mesh.add_child(new_mesh.instance())
	$Trail.modulate = trail_color
	$CollisionShape.scale = collision_size

func drop_facing_random():
	drop_facing(Vector3.FORWARD.rotated(Vector3.UP,rand_range(0.0,3.14)))

func drop_facing(facing_direction:Vector3):
	facing_direction.y += 0.5
	facing_direction = facing_direction.normalized()
	apply_impulse(Vector3.ZERO, Vector3(facing_direction * 18))

func select(_true:bool):
	if _true:
		print("tried to select weapon")
	else:
		print("tried to deselect weapon")
