extends Panel

onready var player_picker = $Margin/VBox/PlayerPicker/Option
onready var back_button = $Margin/VBox/Back
onready var indicator = $Margin/VBox/Settings/Sensitivity/MarginContainer/VBoxContainer2/Indicator
onready var slider = $Margin/VBox/Settings/Sensitivity/MarginContainer/VBoxContainer2/VSlider
onready var affirming_label = $Margin/VBox/Settings/Affirming/Label

var editing_player_idx: int

var devices_used = {
	0:InputEventMouseMotion,
	1:InputEventJoypadMotion,
	2:InputEventJoypadMotion,
	3:InputEventJoypadMotion}

var look_sensitivities = {
	0 : 0.3,
	1 : 1.0,
	2 : 1.0,
	3 : 1.0
}

func _ready():
	player_picker.connect("item_selected",self,"change_player")
	back_button.connect("pressed",get_tree(),"change_scene",["res://menus/settings.tscn"])
	$Margin/VBox/Settings/DevicePicker/Controller.connect("pressed",self,"use_controller",[true])
	$Margin/VBox/Settings/DevicePicker/Mouse.connect("pressed",self,"use_controller",[false])
	indicator.text = "%s" % [look_sensitivities[editing_player_idx]]
	update_affirming_label()
	$Margin/VBox/PlayerPicker/Option.grab_focus()

func change_player(index:int):
	editing_player_idx = index
	indicator.text = "%s" % [look_sensitivities[editing_player_idx]]
	slider.value = look_sensitivities[editing_player_idx]
	update_affirming_label()

func update_affirming_label():
	var plaintext_devices = ["mouse", "controller", "mouse", "controller"]
	for i in 4:
		if devices_used[i] == InputEventJoypadMotion:
			plaintext_devices[i] = "controller"
		elif devices_used[i] == InputEventMouseMotion:
			plaintext_devices[i] = "mouse"
	affirming_label.text = (
	"Player 1: %s \nPlayer 2: %s \nPlayer 3: %s \nPlayer 4: %s" %
	[plaintext_devices[0], plaintext_devices[1], plaintext_devices[2], plaintext_devices[3]]
)

func use_controller(_true:bool):
	if _true:
		devices_used[editing_player_idx] = InputEventJoypadMotion
	else:
		devices_used[editing_player_idx] = InputEventMouseMotion
	get_tree().call_group("Players", "update_devices_used")
	update_affirming_label()


func _on_VSlider_value_changed(value):
	print(value)
	indicator.text = "%s" % [value]
	look_sensitivities[editing_player_idx] = value
