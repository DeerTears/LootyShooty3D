extends Resource

class_name meta

enum rarity{
	BLAND,
	GOOD,
	GREAT,
	AMAZING,
	LEGENDARY,
	SECRET,
}

enum guntype{
	PISTOL,
	SMG,
	RIFLE,
	SHOTGUN,
	SNIPER,
	KIT,
}

# item_body's collider is updated to this size based on the attached gun resource guntype
const guntype_collision_size = {
	guntype.PISTOL:	Vector3(0.5, 0.2, 0.5),
	guntype.SMG:	Vector3(1, 1, 1),
	guntype.RIFLE:	Vector3(2, 0.4, 1),
	guntype.SHOTGUN:Vector3(2, 0.4, 1),
	guntype.SNIPER:	Vector3(1, 1, 1),
}

const guntype_mesh_path = {
	guntype.PISTOL:	"res://models/pistol/pistol.tscn",
	guntype.SMG:	"res://models/pistol/pistol.tscn",
	guntype.RIFLE:	"res://models/pistol/pistol.tscn",
	guntype.SHOTGUN:"res://models/shotgun/shotgun.tscn",
	guntype.SNIPER:	"res://models/pistol/pistol.tscn",
}

const rarity_colors = {
	rarity.BLAND:Color.white,
	rarity.GOOD:Color.green,
	rarity.GREAT:Color(0.27,0.27,0.85),
	rarity.AMAZING:Color.purple,
	rarity.LEGENDARY:Color.orange,
	rarity.SECRET:Color.coral
}

const gunlist = [
	"res://items/guns/bland_smg.tres",
	"res://items/guns/great_shotgun.tres",
	"res://items/guns/bland_pistol.tres",
	"res://items/guns/great_pistol.tres",
	"res://items/guns/bland_shotgun.tres",
]
