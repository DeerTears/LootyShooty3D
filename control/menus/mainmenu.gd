extends Panel

onready var play_romp = $MarginContainer/VBoxContainer/Grid/Romp
onready var play_pits
onready var play_keep
onready var about = $MarginContainer/VBoxContainer/Grid/About
onready var quit = $MarginContainer/VBoxContainer/Grid/Quit
onready var settings = $MarginContainer/VBoxContainer/Grid/Settings
onready var itch_link = $MarginContainer/VBoxContainer/PanelContainer2/HBoxContainer/LinkButton

func _ready():
	if MenuMusic.is_playing() == false:
		MenuMusic.play()
	play_romp.connect("pressed",self,"play_level",["romp"])
#	play_pits.connect("pressed",self,"play_level",["pits"])
#	play_keep.connect("pressed",self,"play_level",["keep"])
	settings.connect("pressed",get_tree(),"change_scene",["res://menus/settings.tscn"])
	about.connect("pressed",get_tree(),"change_scene",["res://menus/about.tscn"])
	quit.connect("pressed",get_tree(),"quit")
	itch_link.connect("pressed",self,"open_link",["https://deertears.itch.io"])
	$MarginContainer/VBoxContainer/Grid/Romp.grab_focus()

func open_link(url:String):
	OS.shell_open(url)

func play_level(level:String):
	MenuMusic.stop()
	match level:
		"romp":
			GameInfo.ingame = true
			GameInfo.switch_gamestate(GameInfo.GameStates.LOADING)
			get_tree().change_scene("res://levels/romp_multi.tscn")
#		"pits":
#			GameInfo.ingame = true
#			GameInfo.switch_gamestate(GameInfo.GameStates.LOADING)
#			get_tree().change_scene("res://levels/2pits.tscn")
#		"keep":
#			GameInfo.ingame = true
#			GameInfo.switch_gamestate(GameInfo.GameStates.LOADING)
#			get_tree().change_scene("res://levels/keep.tscn")
