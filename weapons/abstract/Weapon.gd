extends Node
class_name Weapon # an abstract weapon class that other WeaponClasses (WeaponPistol, WeaponSMG, etc.) refer to, using the strategy pattern

var pellet_count: int = 1 # determines how many BulletEmitters get added to the WeaponClass that extends this script
var bullet_emitter_path = "res://weapons/components/BulletEmitter.tscn"
var firerate: float = 0.1 # represents current gun's firerate
var swap_time: float = 1.0 # represents current gun's pull-out time

func shoot(): # refactor opportunity: make this function an inheritable behaviour inherited optionally by each gun. though I wonder, for what purpose would that be useful? melee?
	var child_count = get_child_count()
	if child_count == 1:
		get_child(0).shoot()
		return
	for i in get_child_count(): # BulletEmitters are the only children of WeaponClasses
		var current_child = get_child(i) # get all bullet emitters
		current_child.shoot() # shoot them each individually
		# note: BulletEmitters handle accuracy/damage on their own, passed down by the various "update_" functions later in this script

func get_pellets() -> Array: # a function that turns the pellet count into an array of BulletEmitter scenes, ready to be added as children
	var pellet_array: Array
	for i in pellet_count:
		var current_pellet = load(bullet_emitter_path).instance()
		pellet_array.append(current_pellet)
	return pellet_array

func update_firerate(time:float): # all guns share one firerate timer
	firerate = time

func update_swap_time(time:float): # all guns share one weapon swap timer
	swap_time = time

func update_pellet_count(pellets:int): # adds BulletEmitter children to the WeaponClass that called for it, based on the passed pellet count
	pellet_count = pellets
	var pellets_array = get_pellets()
	print("old child count: %s" % [get_child_count()])
	for i in pellets_array.size():
		add_child(pellets_array[i],true)
		print("now serving %s" % [get_child(i).name])
	print("new child count: %s" % [get_child_count()])

func update_damage(dmg:int): # called by a WeaponClass to override each BulletEmitter's damage
	for i in get_child_count():
		var current_child = get_child(i)
		if current_child.get_class() == "Timer":
			continue
		else:
			get_child(i).damage = dmg

func update_accuracy(accuracy:float): # called by a WeaponClass to override each BulletEmitter's accuracy
	for i in get_child_count():
		var current_child = get_child(i)
		if current_child.get_class() == "Timer":
			continue
		else:
			get_child(i).accuracy = accuracy
