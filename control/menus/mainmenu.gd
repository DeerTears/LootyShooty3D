extends Panel

onready var start = $MarginContainer/VBoxContainer/Buttons/Start
onready var settings = $MarginContainer/VBoxContainer/Buttons/Settings
onready var quit = $MarginContainer/VBoxContainer/Buttons/Quit

onready var itch_link = $MarginContainer/VBoxContainer/Right/MoreGames
onready var patch_notes = $MarginContainer/VBoxContainer/Left/VBoxContainer/HBoxContainer/PatchNotes
onready var patch_icon = $MarginContainer/VBoxContainer/Left/VBoxContainer/HBoxContainer/PatchIcon

func _ready():
	start.connect("pressed",self,"play_level",["barracks"])
	start.grab_focus()
	settings.connect("pressed",get_tree(),"change_scene",["res://control/menus/settings.tscn"])
	quit.connect("pressed",get_tree(),"quit")
	
	itch_link.connect("pressed",self,"open_link",["https://deertears.itch.io"])
	patch_notes.connect("pressed",self,"open_patch_notes")
	patch_icon.connect("pressed",self,"open_patch_notes")

func open_link(url:String):
	OS.shell_open(url)

func play_level(level:String):
	get_tree().change_scene("res://levels/%s.tscn" % [level])

func open_patch_notes():
	pass
