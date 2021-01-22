extends Node
class_name Weapon

signal shoot

var pellet_count: int = 1
var bullet_emitter_path = "res://weapons/components/BulletEmitter.tscn"
var item_body_path = "res://weapons/components/ItemBody.tscn"
onready var firerate_timer = Timer.new()
# bug: timer is not oneshot and autostarts

func update_firerate(time:float):
	firerate_timer.wait_time = time #todo??

func get_pellets() -> Array:
	var pellet_array: Array
	for i in pellet_count:
		var current_pellet = load(bullet_emitter_path).instance()
		pellet_array.append(current_pellet)
	return pellet_array

func update_pellet_count(pellets:int):
	pellet_count = pellets
	var pellets_array = get_pellets()
	print("old child count: %s" % [get_child_count()])
	for i in pellets_array.size():
		add_child(pellets_array[i],true)
		print("now serving %s" % [get_child(i).name])
	print("new child count: %s" % [get_child_count()])

func shoot():
	emit_signal("shoot")
	print("error: tried to shoot but shooting wasn't defined!")
