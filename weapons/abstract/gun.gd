extends Resource

class_name gun

export(String) var name = ""
export(meta.guntype) var guntype = meta.guntype.PISTOL
export(meta.rarity) var rarity = meta.rarity.BLAND
export(int) var pellet_count = 1
export(int) var damage = 10
export(float, 0.00, 1.00, 0.01) var accuracy = 0.95
export(float, 0.01, 3.0, 0.01) var firerate = 1.00
export(float) var swap_speed = 1.0 # depreciated
export(float) var swap_time = 1.0
export(float) var bullet_range = 150
export(bool) var not_inventory_placeholder = true
