extends VBoxContainer

var audio_bus_name : String setget set_audio_bus_name

var bus : int
onready var mute := $H/Mute
onready var volume_slider := $VolumeSlider
onready var bus_label := $BusLabel


# Sets the label to the audio bus name
func set_audio_bus_name(val : String) -> void:
	bus = AudioServer.get_bus_index(val)
	assert(bus != -1, "'" + val + "' is not a valid audio bus name")
	audio_bus_name = val
	bus_label.text = val
	load_data()


# Updates save data as well as bus volume
func _on_VolumeSlider_value_changed(value : float) -> void:
	Save.data[audio_bus_name]["volume"] = value
	AudioServer.set_bus_volume_db(bus, linear2db(value))


# Loads data from Save singleton
# If no data, loads default data from AudioServer
func load_data() -> void:
	if not audio_bus_name in Save.data:
		var bus_volume = db2linear(AudioServer.get_bus_volume_db(bus))
		var is_bus_mute = AudioServer.is_bus_mute(bus)
		Save.data[audio_bus_name] = {
			"default_volume": bus_volume,
			"default_muted": is_bus_mute,
			"volume": bus_volume,
			"muted": is_bus_mute,
		}
	var volume = Save.data[audio_bus_name]["volume"]
	volume_slider.value = volume
	AudioServer.set_bus_volume_db(bus, linear2db(volume))
	var muted = Save.data[audio_bus_name]["muted"]
	mute.pressed = muted
	_on_Mute_toggled(muted)
	AudioServer.set_bus_mute(bus, muted)


# Updates Save mute
# Sets bus mute value
func _on_Mute_toggled(button_pressed : bool) -> void:
	if button_pressed:
		mute.icon = preload("res://Assets/UI/Mute.png")
	else:
		mute.icon = preload("res://Assets/UI/Speaker.png")
	Save.data[audio_bus_name]["muted"] = button_pressed
	AudioServer.set_bus_mute(bus, button_pressed)


# Resets volume to default values
func reset() -> void:
	volume_slider.value = Save.data[audio_bus_name]["default_volume"]
	mute.pressed = Save.data[audio_bus_name]["default_muted"]
