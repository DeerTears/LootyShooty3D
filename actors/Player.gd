extends Actor

# selecting and picking guns
var new_item_selected

# character controller
var h_acceleration = 3
var air_acceleration = 1
var normal_acceleration = 7
var gravity = 26
var jump = 18
var full_contact = false
var alive: bool = true

onready var pickup_notice = $Control/CenterContainer/PickupNotice
export var mouse_sensitivity = 0.15

var h_velocity = Vector3()

onready var head = $Head
onready var ground_check = $GroundCheck

func _ready():
	speed = 22
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
		body.select(false)
		pickup_notice.hide()

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))
	if event.is_action_pressed("ui_cancel"):
		if OS.window_fullscreen:
			OS.window_fullscreen = false
		else:
			OS.window_fullscreen = true
	if not alive:
		return
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

func hurt(damage:int):
	health -= damage
	print("I got hit for %s!" % [damage])
	$Control/Effects/AnimationPlayer.play("Hurt")
	if health <= 0:
		die()

func die():
	queue_free()

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
	if not alive:
		direction = Vector3.ZERO
	direction = direction.normalized()
	h_velocity = h_velocity.linear_interpolate(direction * speed, h_acceleration * delta)
	velocity.z = h_velocity.z + gravity_vec.z
	velocity.x = h_velocity.x + gravity_vec.x
	velocity.y = gravity_vec.y
	move_and_slide(velocity, Vector3.UP)
	GameInfo.player_position = global_transform.origin


func _on_Animations_animation_finished(anim_name):
	pass	
#	match anim_name:
#		"ReadyPistol":
#			$Head/Camera/Animations.play("IdlePistol")
#		"FirePistol":
#			$Head/Camera/Animations.play("IdlePistol")


func on_weapon_fired(weapon_name:String,total_time_for_animation_to_complete:float):
	$Head/Camera/Animations.playback_speed = 1.0
	match weapon_name:
		"Pistol":
			$Head/Camera/Animations.stop()
			$Head/Camera/Animations.play("FirePistol")
		"Shotgun":
			$Head/Camera/Animations.stop()
			$Head/Camera/Animations.play("FirePistol")
		"SMG":
			$Head/Camera/Animations.stop()
			$Head/Camera/Animations.play("FireSMG")
	print("%s, %s" % [weapon_name, total_time_for_animation_to_complete])


func on_weapon_swapped(weapon_name:String,total_time_for_animation_to_complete:float):
	$Head/Camera/Viewmodel/PistolMesh.hide()
	$Head/Camera/Viewmodel/ShotgunMesh.hide()
	$Head/Camera/Viewmodel/SMGMesh.hide()
	match weapon_name:
		"Pistol":
			$Head/Camera/Animations.stop()
			$Head/Camera/Viewmodel/PistolMesh.show()
			$Head/Camera/Animations.play("ReadyPistol")
			$Head/Camera/Animations.playback_speed = 1.0
		"Shotgun":
			$Head/Camera/Animations.stop()
			$Head/Camera/Viewmodel/ShotgunMesh.show()
			$Head/Camera/Animations.play("ReadyPistol")
			$Head/Camera/Animations.playback_speed = 0.6
		"SMG":
			$Head/Camera/Animations.stop()
			$Head/Camera/Viewmodel/SMGMesh.show()
			$Head/Camera/Animations.play("ReadyPistol")
			$Head/Camera/Animations.playback_speed = 1.6
		"Sniper":
			pass
