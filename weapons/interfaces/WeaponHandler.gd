extends Node

onready var current_weapon = get_node("WeaponPistol")

func _input(event):
	if event.is_action_pressed("switch_1"):
		current_weapon = get_node("WeaponPistol")
	if event.is_action_pressed("switch_2"):
		current_weapon = get_node("WeaponShotgun")
	if event.is_action_pressed("switch_3"):
		current_weapon = get_node("WeaponSMG")
	if event.is_action_pressed("switch_4"):
		current_weapon = get_node("WeaponSniper")

func _physics_process(delta):
	if Input.is_action_pressed("fire"):
			current_weapon.shoot()
