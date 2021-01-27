extends Actor

enum {
	IDLE,
	AIMING,
	FIRING,
	DEAD,
}
var state = IDLE

func _ready():
	change_state(state)

func _on_Autodetect_body_entered(_body):
	change_state(AIMING)

func _physics_process(_delta):
	if $Head/RayCast.is_colliding():
		change_state(FIRING)
	else:
		change_state(AIMING)

func change_state(new_state:int):
	state = new_state
	match state:
		IDLE:
			pass
		AIMING:
#			var true_position = GameInfo.player_position
			# todo: use direction_to
			# this will create a normalized direction vector that we can lerp our -basis.z with, using delta as the weight?
			$Head.look_at(GameInfo.player_position, Vector3.UP)
		FIRING:
			$Head/AnimationPlayer.play("Firing")
			$Head.look_at(GameInfo.player_position, Vector3.UP)
			# todo: add target raycast to deal damage
			# maybe even a timer just like what i have in the WeaponHandler, but simpler
#			target.hurt(enemy_damage)
		DEAD:
			$Head/AnimationPlayer.play("Dead")
			yield($Head/AnimationPlayer,"animation_finished")
			die()
