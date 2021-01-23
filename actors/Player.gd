extends KinematicBody

# selecting and picking guns
var new_item_selected
export(Resource) var gun_resource

# character controller
var speed = 22
var h_acceleration = 3
var air_acceleration = 1
var normal_acceleration = 7
var gravity = 26
var jump = 18
var full_contact = false

onready var pickup_notice = $Control/CenterContainer/PickupNotice
export var mouse_sensitivity = 0.15

var direction = Vector3()
var h_velocity = Vector3()
var movement = Vector3()
var gravity_vec = Vector3()

onready var head = $Head
onready var ground_check = $GroundCheck

func _ready():
	$Head/EditorArrow.hide()
	$Control/CenterContainer/PickupNotice.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_PickupArea_body_entered(body):
	if "gun_resource" in body:
		if body.downtime_active:
			return
		var old_item_selected
		if new_item_selected != null:
			old_item_selected = new_item_selected
			old_item_selected.select(false)
		new_item_selected = body
		new_item_selected.set_downtime_active(true)
		new_item_selected.select(true)
		var new_gun_resource = new_item_selected.gun_resource
		pickup_notice.show()
		pickup_notice.get_child(0).text = "press 'E' to pickup %s" % [new_gun_resource.name]
		print("%s, %s, %s" % [new_gun_resource.guntype, new_gun_resource.rarity, new_gun_resource.name])

func _on_PickupArea_body_exited(body):
	if "gun_resource" in body:
#		body.drop_facing(-transform.basis.z)
		body.select(false)
		pickup_notice.hide()

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))
		$Control/Debug/Label.text = "%s\n%s" % [head.rotation, head.rotation.x]
	if event.is_action_pressed("ui_cancel"):
		if OS.window_fullscreen:
			OS.window_fullscreen = false
		else:
			OS.window_fullscreen = true
	if event.is_action_pressed("drop"):
		# bug: guns roll with player pitch view, messes up particles, really annoying, makes no sense
#		$Head/GunDropper.direction = -transform.basis.z
#		$Head/GunDropper.drop_random_gun()
		drop_gun()

func drop_gun():
	var new_gun = load("res://weapons/components/ItemBody.tscn").instance()
	new_gun.global_transform = self.global_transform
	new_gun.drop_trajectory = -transform.basis.z
	new_gun.gun_resource = load(meta.gunlist[randi() % meta.gunlist.size() - 1])
	get_tree().root.add_child(new_gun)

func _physics_process(delta):
	direction = Vector3()
	full_contact = ground_check.is_colliding()
	
	if not is_on_floor():
		gravity_vec += Vector3.DOWN * gravity * delta
		h_acceleration = air_acceleration
	elif is_on_floor() and full_contact:
		gravity_vec = -get_floor_normal() * gravity
		h_acceleration = normal_acceleration
	else:
		gravity_vec = -get_floor_normal()
		h_acceleration = normal_acceleration
		
	if Input.is_action_just_pressed("jump") and (is_on_floor() or ground_check.is_colliding()):
		gravity_vec = Vector3.UP * jump
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	direction = direction.normalized()
	h_velocity = h_velocity.linear_interpolate(direction * speed, h_acceleration * delta)
	movement.z = h_velocity.z + gravity_vec.z
	movement.x = h_velocity.x + gravity_vec.x
	movement.y = gravity_vec.y
	move_and_slide(movement, Vector3.UP)


#$Head/Camera/Animations.play("Fire")


func _on_Animations_animation_finished(anim_name):
	match anim_name:
		"Fire":
			$Head/Camera/Animations.play("Idle")
		"Ready":
			$Head/Camera/Animations.play("Idle")


func on_weapon_fired(weapon_name:String,total_time_for_animation_to_complete:float):
	match weapon_name:
		"Pistol":
			$Head/Camera/Animations.play("Fire")
		"Shotgun":
			pass
	
	print("%s, %s" % [weapon_name, total_time_for_animation_to_complete])
