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

func on_weapon_swapped(weapon_name:String,_total_time_for_animation_to_complete:float):
	for i in $Head/Camera/Viewmodel.get_child_count():
		$Head/Camera/Viewmodel.get_child(i).hide()
	$Head/Camera/Animations.stop()
	match weapon_name:
		"Pistol":
			$Head/Camera/Viewmodel/PistolMesh.show()
			$Head/Camera/Animations.play("ReadyPistol")
			$Head/Camera/Animations.playback_speed = 1.0
		"Shotgun":
			$Head/Camera/Viewmodel/ShotgunMesh.show()
			$Head/Camera/Animations.play("ReadyPistol")
			$Head/Camera/Animations.playback_speed = 0.6
		"SMG":
			$Head/Camera/Viewmodel/SMGMesh.show()
			$Head/Camera/Animations.play("ReadyPistol")
			$Head/Camera/Animations.playback_speed = 1.6
		"Sniper":
			$Head/Camera/Viewmodel/SniperMesh.show()
			$Head/Camera/Animations.play("ReadyPistol")
			$Head/Camera/Animations.playback_speed = 0.4
