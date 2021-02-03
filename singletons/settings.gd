extends Node

var volume = {
	"Master":0.0,
	"Reverb":0.0,
	"PlayerGuns":0.0,
	"EnemyBarks":0.0,
	"EnemyGuns":0.0,
	"Footsteps":0.0,
	"Ambient":0.0,
	"Music":0.0,
	"UI":0.0,
}

enum {
	HIGH,
	MEDIUM,
	LOW,
}

func _ready():
	yield(get_tree().create_timer(2.0),"timeout")
	print("update glow?")
	update_graphics_property("glow", LOW)

func update_graphics_property(property, level):
	match property:
		"glow":
			match level:
				HIGH:
					get_tree().call_group("Environment", "set_glow_enabled", true)
				MEDIUM:
					get_tree().call_group("Environment", "set_glow_enabled", true)
				LOW:
					print("mhm")
					get_tree().call_group("Environment", "set_glow_enabled", false)
					#why not?
		"shadows":
			match level:
				HIGH:
					pass
				MEDIUM:
					pass
				LOW:
					pass
