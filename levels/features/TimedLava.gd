extends Area
var total = 0.0
export (int) var damage = 5
export (float) var sustain_time = 1.0
var lava_active: bool = false
var body_on_lava: bool = false
var last_body

func _ready():
	total = 0.0

func on_body_entered(body):
	if body.is_in_group("Player") == false:
		return
	body_on_lava = true
	while overlaps_body(body) and lava_active:
		body.hurt(damage)
#		last_body = body
		$HurtTimer.start()
		yield($HurtTimer,"timeout")

func _process(delta):
	total += delta # lazy sin timer
	var result = sin(total/1.9)
	result = clamp(result,0.0,0.85) # don't make the lava weird looking
	if result >= 0.225:
		lava_active = true
#		if last_body != null:
#			on_body_entered(last_body)
	else:
		lava_active = false
	$MeshInstance.material_override.set_shader_param("emission_energy", result)
