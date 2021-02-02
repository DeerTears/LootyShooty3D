extends Spatial

func on_weapon_fired(weapon_name:String,_total_time_for_animation_to_complete:float):
	$Head/Camera/Animations.playback_speed = 1.0
	match weapon_name:
		"Pistol":
			$Head/Camera/Animations.stop()
			$Head/Camera/Animations.play("FirePistol")
			$Sounds/Guns/ShootSMG.play()
		"Shotgun":
			$Head/Camera/Animations.stop()
			$Head/Camera/Animations.play("FirePistol")
		"SMG":
			$Head/Camera/Animations.stop()
			$Head/Camera/Animations.play("FireSMG")
			$Sounds/Guns/ShootSMG.play()
		"Sniper":
			$Head/Camera/Animations.playback_speed = 0.2
			$Head/Camera/Animations.play("FireSMG")
