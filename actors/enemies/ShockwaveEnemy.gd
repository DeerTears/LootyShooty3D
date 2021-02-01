extends Enemy

func change_state(new_state:int):
	state = new_state
	match state:
		IDLE:
			pass
		ENGAGE:
#			$Sounds/Laughs.play()
			pass
		BACK_AWAY:
			random_misdirection_phi = rand_range(0.0,1.1745329)
			yield(get_tree().create_timer(1.2),"timeout")
			change_state(WARY)
		WARY:
			yield(get_tree().create_timer(0.25),"timeout")
			change_state(ENGAGE)
		SWING:
			$AnimationPlayer.play("AttackShockwave")
			yield(get_tree().create_timer(1.5),"timeout")
			change_state(BACK_AWAY)
		DEAD:
			if loot_claimed: # todo: does disabling this re-enable getting multiple guns with a shotgun?
				return
			loot_claimed = true
			if 1 == 1: # todo: if we should drop a gun...
#				$GunDropper.direction = -transform.basis.z
#				$GunDropper.drop_random_gun()
				pass
			$PresenceDetector/CollisionShape.disabled = true
#			$PlayerDetector/CollisionShape.disabled = true
			self.set_collision_layer_bit(3,false)
			self.set_collision_mask_bit(1, false)
			self.set_collision_mask_bit(3, false)
#			$AnimationPlayer.play("Die")
#			$Sounds/Die.play()
#			yield($AnimationPlayer,"animation_finished")
			queue_free()

func hurt(damage:int):
	health -= damage
	print("Enemy was hit for %s!" % [damage])
	velocity *= 1.0 - (damage/max_health) # refactor: find out if this is doing anything?
	if health <= 0:
		change_state(DEAD)
		return
	else:
#		$AnimationPlayer.play("Hurt")
#		if $Sounds/Hurt.playing == false:
#			$Sounds/Hurt.play()
		pass
	if state == IDLE:
		change_state(ENGAGE)
