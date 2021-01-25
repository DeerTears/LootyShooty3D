extends Resource

class_name meta

enum rarity{
	BLAND,
	GOOD,
	AMAZING,
	SECRET,
}

enum guntype{
	PISTOL,
	SMG,
	RIFLE,
	SHOTGUN,
	SNIPER,
}

# item_body's collider is updated to this size based on the attached gun resource guntype
const guntype_collision_size = {
	guntype.PISTOL:	Vector3(0.5, 0.4, 0.5),
	guntype.SMG:	Vector3(1.0, 0.4, 0.5),
	guntype.RIFLE:	Vector3(2.0, 0.4, 1.0),
	guntype.SHOTGUN:Vector3(2.0, 0.4, 1.0),
	guntype.SNIPER:	Vector3(2.0, 0.4, 1.0),
}

const guntype_mesh_path = {
	guntype.PISTOL:	"res://models/pistol/pistol.tscn",
	guntype.SMG:	"res://models/smg/smg.tscn",
	guntype.RIFLE:	"res://models/smg/smg.tscn",
	guntype.SHOTGUN:"res://models/shotgun/shotgun.tscn",
	guntype.SNIPER:	"res://models/sniper/sniper.tscn",
}

const rarity_colors = {
	rarity.BLAND:Color.white,
	rarity.GOOD:Color.green,
	rarity.AMAZING:Color.purple,
	rarity.SECRET:Color.coral
}

const gunlist = [
	"res://weapons/saved/amazing_sniper.tres",
	
	"res://weapons/saved/bland_pistol.tres",
	"res://weapons/saved/bland_shotgun.tres",
	"res://weapons/saved/bland_smg.tres",
	"res://weapons/saved/bland_sniper.tres",
	
	"res://weapons/saved/secret_shotgun.tres",
]
