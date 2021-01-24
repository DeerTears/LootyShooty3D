extends Node

# args: (weapon_suffix:String, wait_time:float)
signal swapped # for connecting weapon swap animations
signal fired # for connecting shoot animations

# args: (weapon_suffix:String)
signal gun_should_be_idle # for debugging/bruteforcing swapped animations

enum weapon_idx { # our scrollable list of weapons
	PISTOL,
	SHOTGUN,
	SMG,
	SNIPER
}
var holding_idx = 0 # and our current place in the list

const weapon_names = [ # our suffixes for each WeaponClass class, dynamically using get_node() with "%s"
	"Pistol",
	"Shotgun",
	"SMG",
	"Sniper",
]

onready var current_weapon = get_node("WeaponPistol") # only one weapon can be shot at a time
onready var firerate_timer = $FirerateTimer # all guns share a firerate timer, use update_firerate on a WeaponClass at runtime to change this
onready var swap_timer = $SwapTimer# same goes for swap timer, use update_swaptime in a WeaponClass class to change it for that gun

func _ready():
	firerate_timer.wait_time = current_weapon.firerate
	swap_timer.wait_time = current_weapon.swap_time

func _input(event):
	if event.is_action_type() == false:
		return
	var old_holding_idx = holding_idx
	if event.is_action_pressed("switch_1"):
		holding_idx = weapon_idx.PISTOL
	if event.is_action_pressed("switch_2"):
		holding_idx = weapon_idx.SHOTGUN
	if event.is_action_pressed("switch_3"):
		holding_idx = weapon_idx.SMG
	if event.is_action_pressed("switch_4"):
		holding_idx = weapon_idx.SNIPER
	if event.is_action_pressed("switch_next"):
		holding_idx += 1
		if holding_idx > weapon_idx.size() - 1:
			holding_idx = 0
	if event.is_action_pressed("switch_previous"):
		holding_idx -= 1
		if holding_idx < 0:
			holding_idx = weapon_idx.SNIPER
	if old_holding_idx != holding_idx:
		current_weapon = get_node("Weapon%s" % [weapon_names[holding_idx]])
		emit_signal("swapped", weapon_names[holding_idx], swap_timer.wait_time)
		print_debug("swapped to %s" % [current_weapon.name])
		swap_timer.wait_time = current_weapon.swap_time
		swap_timer.start()
		firerate_timer.wait_time = current_weapon.firerate
		firerate_timer.stop()

func _physics_process(_delta):
	if Input.is_action_pressed("fire") and firerate_timer.is_stopped() and swap_timer.is_stopped():
			current_weapon.shoot()
			firerate_timer.start()
			emit_signal("fired", weapon_names[holding_idx], firerate_timer.wait_time)
	$Panel/Label.text = "%s\n%s" % [firerate_timer.time_left, swap_timer.time_left]

func _on_SwapTimer_timeout():
	if firerate_timer.is_stopped():
		emit_signal("gun_should_be_idle", weapon_names[holding_idx])

func _on_FirerateTimer_timeout():
	if swap_timer.is_stopped():
		emit_signal("gun_should_be_idle", weapon_names[holding_idx])
