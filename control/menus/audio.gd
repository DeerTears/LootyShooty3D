extends Panel

onready var master_indicator = $Margin/VBox/Sliders/Master/VBox/MasterIndicator
onready var master_slider = $Margin/VBox/Sliders/Master/VBox/MasterSlider
onready var sfx_indicator = $Margin/VBox/Sliders/SFX/VBox/SFXIndicator
onready var sfx_slider = $Margin/VBox/Sliders/SFX/VBox/SFXSlider
onready var music_indicator = $Margin/VBox/Sliders/Music/VBox/MusicIndicator
onready var music_slider = $Margin/VBox/Sliders/Music/VBox/MusicSlider

func _ready():
	master_slider.value = Settings.volume[0]
	music_slider.value = Settings.volume[1]
	sfx_slider.value = Settings.volume[2]
	master_indicator.text = "%sdb" % [master_slider.value]
	music_indicator.text = "%sdb" % [music_slider.value]
	sfx_indicator.text = "%sdb" % [sfx_slider.value]
	music_slider.connect("value_changed", self, "_on_MusicSlider_value_changed")
	master_slider.connect("value_changed", self, "_on_MasterSlider_value_changed")
	sfx_slider.connect("value_changed", self, "_on_SFXSlider_value_changed")
	$Margin/VBox/Sliders/Master/VBox/MasterSlider.grab_focus()

func _on_Button_pressed():
	get_tree().change_scene("res://menus/settings.tscn")

func _on_MasterSlider_value_changed(value):
	master_indicator.text = "%sdb" % [value]
	AudioServer.set_bus_volume_db(0, value)
	Settings.volume[0] = value
	if $Test.is_playing():
		return
	$Test.play()

func _on_MusicSlider_value_changed(value):
	music_indicator.text = "%sdb" % [value]
	AudioServer.set_bus_volume_db(1, value)
	Settings.volume[1] = value

func _on_SFXSlider_value_changed(value):
	sfx_indicator.text = "%sdb" % [value]
	AudioServer.set_bus_volume_db(2, value)
	Settings.volume[2] = value
	if $Test.is_playing():
		return
	$Test.play()
