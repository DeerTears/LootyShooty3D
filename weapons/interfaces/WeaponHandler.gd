extends Node

# args: (weapon_suffix:String, wait_time:float)
signal swapped # for connecting weapon swap animations
signal fired # for connecting shoot animations

var slot_idx = 0 # our current place in the list
var inventory_size: int = 2
var active_weapon: Node

const weapon_names = [ # our suffixes for each WeaponClass class, dynamically using get_node() with "%s"
	"Pistol",
	"Shotgun",
	"SMG",
	"Sniper",
]

onready var firerate_timer = $FirerateTimer # All slots share a firerate timer, use update_firerate through WeaponSlot at runtime to change this.
onready var swap_timer = $SwapTimer # same goes for the weapon swap timer, use update_swaptime in a WeaponSlot to change the swap time for the weapon it's responsible for.

func _ready():
	update_inventory_size()
	active_weapon = get_node("Slots/WeaponSlot0/Weapon")
	update_timers()
	start_swap_timer()
	emit_signal("swapped","Pistol", active_weapon.swap_time)

func update_inventory_size():
	inventory_size = $Slots.get_child_count()
#	for i in inventory_size:
#		print($Slots.get_child(i).gun_resource.name)

func _input(event):
	var old_slot_idx = slot_idx
	if event.is_action_pressed("switch_1"):
		slot_idx = 0
	if event.is_action_pressed("switch_2"):
		slot_idx = 1
	if event.is_action_pressed("switch_3"):
		if inventory_size > 2:
			slot_idx = 2
		else:
			return
	if event.is_action_pressed("switch_4"):
		if inventory_size > 3:
			slot_idx = 3
		else:
			return
	if event.is_action_pressed("switch_next"):
		slot_idx += 1
	if event.is_action_pressed("switch_previous"):
		slot_idx -= 1
	
	if slot_idx > inventory_size - 1:
		slot_idx = 0
	if slot_idx < 0:
		slot_idx = inventory_size - 1
	if old_slot_idx != slot_idx:
		active_weapon = get_node("Slots/WeaponSlot%s/Weapon" % [slot_idx])
		update_timers()
		start_swap_timer()


func update_timers():
	swap_timer.wait_time = active_weapon.swap_time
	firerate_timer.wait_time = active_weapon.firerate


func start_swap_timer():
	emit_signal("swapped", weapon_names[slot_idx], swap_timer.wait_time)
	print_debug("swapped to %s" % [active_weapon.name])
	swap_timer.start()
	firerate_timer.stop()


func _physics_process(_delta):
	if Input.is_action_pressed("fire") and firerate_timer.is_stopped() and swap_timer.is_stopped():
			active_weapon.shoot()
			firerate_timer.start()
			emit_signal("fired", weapon_names[slot_idx], firerate_timer.wait_time)
	$Panel/Label.text = "%s\n%s" % [firerate_timer.time_left, swap_timer.time_left]
