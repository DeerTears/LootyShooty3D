extends Spatial

export (String) var scene_path_to_spawn
export (float) var interval = 2.0
export (int) var max_active_copies = 3 # -1 to disable max_active_copies system
export (int) var lifetime_copies = 20
export (bool) var spawn_on_ready = true # if false, use "spawn" to start spawning
var copy_idx: int = 0

func _ready():
	$EditorMesh.hide()
	copy_idx = 0
	if spawn_on_ready:
		spawn()

func spawn():
	if max_active_copies != -1: 
		if get_node("Children").get_child_count() >= max_active_copies:
			yield(get_tree().create_timer(3.0),"timeout") # refactor: have this yield to any child being removed or emitting a "killed" signal, instead of waiting preset seconds
			spawn()
			return
	copy_idx += 1
	var new_copy = load(scene_path_to_spawn).instance()
	get_node("Children").add_child(new_copy,true)
	if copy_idx >= lifetime_copies:
		print_debug("Spawner: lifetime copies exhausted")
		return
	else:
		yield(get_tree().create_timer(interval),"timeout")
		spawn()
