extends Resource
# A resource that contains speed, health, and other variables for different actors.
# Load a CharacterProfile into the character_profile export for any actor and they /should/ inherit the traits of the profile.
class_name CharacterProfile

export(int)var health = 100
export(int)var max_health = 100
export(float)var speed = 22
export(float)var jump = 18
export(float)var air_acceleration = 1
export(float)var default_acceleration = 7
export(float)var gravity = 26
