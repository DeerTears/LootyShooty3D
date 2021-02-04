extends Area
export (int) var damage = 5 # damage dealt to bodies
export (float) var damage_sustain_time = 1.0 # interval between hurt() calls
export (bool) var lava_active: bool = false # used to track if the lava has stopped flashing or not

# bug: any body exits and all references to bodies are lost
# fix: replace below Node variable with an Array to hold nodes
var last_body = null # used to track if the player is still on the lava when it re-flashes

func _ready():
	$HurtTimer.wait_time = damage_sustain_time

func on_body_entered(body):
	if body.is_in_group("Player") or body.is_in_group("Enemy"):
		last_body = body
		hurt_last_body()

func on_body_exited(body):
	if body == last_body:
		last_body = null
	print("exited | body: %s, last body: %s" % [body, last_body])

func hurt_last_body():
	if last_body == null:
		return
	while overlaps_body(last_body) and lava_active:
		last_body.hurt(damage)
		$HurtTimer.start()
		yield($HurtTimer,"timeout")
		if last_body == null:
			return
