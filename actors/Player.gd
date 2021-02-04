extends Actor

# selecting and picking guns

var current_slot_gun_resource = preload("res://weapons/saved/inventory_placeholder.tres")
var new_gun_selected
var new_gun_resource
var selecting_gun

# character controller
var horizontal_acceleration = 3
var air_acceleration = 1
var default_acceleration = 7
var gravity = 26
var jump = 18
var full_contact = false
var alive: bool = true

onready var hud_pickup_notice = $HUD/CenterContainer/PickupNotice
export var mouse_sensitivity = 0.15

var horizontal_velocity = Vector3()

onready var head = $Head
onready var ground_check = $GroundCheck

func _ready():
	speed = 22
	$Mesh/EditorArrow.hide()
	hud_pickup_notice.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if character_profile == null:
		print("no character profile!")
	else:
		speed = character_profile.speed
		health = character_profile.health
		max_health = character_profile.max_health
		jump = character_profile.jump
		air_acceleration = character_profile.air_acceleration
		default_acceleration = character_profile.default_acceleration
		gravity = character_profile.gravity

func _on_PickupArea_body_entered(body):
	if "gun_resource" in body:
		new_gun_selected = body
		new_gun_resource = new_gun_selected.gun_resource
		hud_pickup_notice.show() # refactor: move notice to not be in the dead middle of the screen
		hud_pickup_notice.get_child(0).text = "press 'E' to pickup %s" % [new_gun_resource.name]
		selecting_gun = true
		# todo: have this result update our WeaponSlotsHandler's gun_resource for its current slot

func _on_PickupArea_body_exited(body):
	if "gun_resource" in body:
		hud_pickup_notice.hide()
		selecting_gun = false

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
	if event.is_action_pressed("use") and selecting_gun:
		pickup_gun()
		new_gun_selected.queue_free()
	if event.is_action_pressed("drop"):
		drop_gun()

func pickup_gun():
	var current_slot = $Head/WeaponSlotsHandler.slot_idx
	print("old: %s" % [$Head/WeaponSlotsHandler/Slots.get_child(current_slot).get_gun_resource()])
	$Head/WeaponSlotsHandler/Slots.get_child(current_slot).set_gun_resource(new_gun_resource)
	print("new: %s" % [$Head/WeaponSlotsHandler/Slots.get_child(current_slot).get_gun_resource()])

func drop_gun():
	var new_gun = load("res://weapons/components/ItemBody.tscn").instance()
	new_gun.global_transform = self.global_transform
	new_gun.drop_trajectory = -transform.basis.z
	if selecting_gun:
		new_gun.gun_resource = new_gun_resource
	if not selecting_gun:
		new_gun.gun_resource = current_slot_gun_resource
	get_tree().root.add_child(new_gun)

func _hurt(): # hurt() is still in tact in actor.gd
	$HUD/Effects/AnimationPlayer.play("Hurt")

func die():
	queue_free()

func _physics_process(delta):
	direction = Vector3()
	full_contact = ground_check.is_colliding()
	if not is_on_floor():
		gravity_vec += Vector3.DOWN * gravity * delta
		horizontal_acceleration = air_acceleration
	elif is_on_floor() and full_contact:
		gravity_vec = -get_floor_normal() * gravity
		horizontal_acceleration = default_acceleration
	else:
		gravity_vec = -get_floor_normal()
		horizontal_acceleration = default_acceleration
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
	horizontal_velocity = horizontal_velocity.linear_interpolate(direction * speed, horizontal_acceleration * delta)
	velocity.z = horizontal_velocity.z + gravity_vec.z
	velocity.x = horizontal_velocity.x + gravity_vec.x
	velocity.y = gravity_vec.y
	move_and_slide(velocity, Vector3.UP)
	GameInfo.player_position = global_transform.origin

func on_weapon_fired(weapon_name:String,_total_time_for_animation_to_complete:float):
	$Head/Camera/Animations.playback_speed = 1.0
	match weapon_name:
		"Pistol":
			$Head/Camera/Animations.stop()
			$Head/Camera/Animations.play("FirePistol")
			$Sounds/Guns/ShootSMG.play()
		"Shotgun":
			$Head/Camera/Animations.stop()
			$Head/Camera/Animations.play("FirePistol")
		"SMG":
			$Head/Camera/Animations.stop()
			$Head/Camera/Animations.play("FireSMG")
			$Sounds/Guns/ShootSMG.play()
		"Sniper":
			$Head/Camera/Animations.playback_speed = 0.2
			$Head/Camera/Animations.play("FireSMG")

func on_weapon_swapped(weapon_name:String,_total_time_for_animation_to_complete:float):
	for i in $Head/Camera/Viewmodel.get_child_count():
		$Head/Camera/Viewmodel.get_child(i).hide()
	$Head/Camera/Animations.stop()
	match weapon_name:
		"Pistol":
			$Head/Camera/Viewmodel/PistolMesh.show()
			$Head/Camera/Animations.play("ReadyPistol")
			$Head/Camera/Animations.playback_speed = 1.0
		"Shotgun":
			$Head/Camera/Viewmodel/ShotgunMesh.show()
			$Head/Camera/Animations.play("ReadyPistol")
			$Head/Camera/Animations.playback_speed = 0.6
		"SMG":
			$Head/Camera/Viewmodel/SMGMesh.show()
			$Head/Camera/Animations.play("ReadyPistol")
			$Head/Camera/Animations.playback_speed = 1.6
		"Sniper":
			$Head/Camera/Viewmodel/SniperMesh.show()
			$Head/Camera/Animations.play("ReadyPistol")
			$Head/Camera/Animations.playback_speed = 0.4
