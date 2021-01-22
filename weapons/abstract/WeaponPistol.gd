extends Weapon

# todo: there's gotta be some way of inserting the below information via resource, right? the script doesn't even need to be spatial, it just can't be Resource
func _ready():
	update_firerate(0.5)
	update_swap_time(1.0)
	update_pellet_count(1)
	update_damage(7)
	update_accuracy(0.9)
