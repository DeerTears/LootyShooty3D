extends Actor

enum {
	IDLE,
	WARY,
	ENGAGE,
	SWING,
	BACK_AWAY,
	DEAD
}
var loot_claimed: bool = false
var enemy_damage = 10
var state = IDLE
var random_misdirection_phi: float = 0.0
func _ready():
	change_state(IDLE)

func _on_Player_enter_presence(_body):
	change_state(ENGAGE)

func on_Player_enter_area(_body):
	change_state(SWING)

func _physics_process(_delta):
	direction = Vector3()
	if is_on_floor():
		gravity_vec.y = 0
	else:
		gravity_vec.y = -9.81
	match state:
		ENGAGE:
			direction = global_transform.origin.direction_to(GameInfo.player_position)
		BACK_AWAY:
			direction = global_transform.origin.direction_to(GameInfo.player_position) * -1
			direction = direction.rotated(Vector3.UP,random_misdirection_phi)
		IDLE:
			direction = Vector3.ZERO
		DEAD:
			direction = Vector3.ZERO
	velocity = direction * speed + (Vector3.ONE * gravity_vec)
	velocity.y = gravity_vec.y
	move_and_slide(velocity)
	if state != DEAD:
		if direction.length() > 0:
			var direction_of_travel = global_transform.origin + direction.normalized()
			var old_rotation = rotation
			look_at(direction_of_travel, Vector3.UP)
			rotation.x = old_rotation.x


func change_state(new_state:int):
	state = new_state
	match state:
		IDLE:
			pass
		ENGAGE:
			pass
		BACK_AWAY:
			random_misdirection_phi = rand_range(0.0,1.1745329)
			yield(get_tree().create_timer(1.2),"timeout")
			change_state(WARY)
		WARY:
			yield(get_tree().create_timer(0.25),"timeout")
			change_state(ENGAGE)
		SWING:
			$Poof.emitting = true
			yield(get_tree().create_timer(0.2),"timeout") # simulating animation swing startup
			if $RayCast.is_colliding():
				var target = $RayCast.get_collider()
				if target.is_in_group("Player"):
					target.hurt(enemy_damage)
			yield(get_tree().create_timer(0.2),"timeout") # simulating animation swing slowdown
			change_state(BACK_AWAY)
		DEAD:
			if loot_claimed: # todo: does disabling this re-enable getting multiple guns with a shotgun?
				return
			loot_claimed = true
			if 1 == 1: # todo: if we should drop a gun...
				$GunDropper.direction = -transform.basis.z
				$GunDropper.drop_random_gun()
			$CollisionShape.disabled = true
			$PresenceDetector/CollisionShape.disabled = true
			$PlayerDetector/CollisionShape.disabled = true
			$AnimationPlayer.play("Die")
			yield($AnimationPlayer,"animation_finished")
			queue_free()

func hurt(damage:int):
	health -= damage
	print("Enemy was hit for %s!" % [damage])
	velocity *= 1.0 - (damage/max_health)
#	velocity.x *= 0.1
#	velocity.z *= 0.1
	if health <= 0:
		change_state(DEAD)
		return
	else:
		$AnimationPlayer.play("Hurt")
	if state == IDLE:
		change_state(ENGAGE)
