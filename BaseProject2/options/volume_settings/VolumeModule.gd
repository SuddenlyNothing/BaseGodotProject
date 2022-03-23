extends VBoxContainer

signal updated

var audio_bus_name : String setget set_audio_bus_name

# Is volume and mute at default value
var is_default : bool

var bus : int
var default_mute : bool
var default_volume : float
onready var mute := $H/Mute
onready var mute_icon := $H/Mute/MuteIcon
onready var reset := $H/Reset
onready var volume_slider := $VolumeSlider
onready var bus_label := $H/BusLabel


# Sets the label to the audio bus name
func set_audio_bus_name(val : String) -> void:
	bus = AudioServer.get_bus_index(val)
	assert(bus != -1, "'" + val + "' is not a valid audio bus name")
	audio_bus_name = val
	bus_label.text = val
	load_data()


# Updates save data as well as bus volume
func _on_VolumeSlider_value_changed(value : float) -> void:
	Save.data.audio_buses[audio_bus_name]["volume"] = value
	AudioServer.set_bus_volume_db(bus, linear2db(value))
	set_reset_show()


# Loads data from Save singleton
# If no data, loads default data from AudioServer
func load_data() -> void:
	if not audio_bus_name in Save.data.audio_buses:
		var bus_volume = db2linear(AudioServer.get_bus_volume_db(bus))
		var is_bus_mute = AudioServer.is_bus_mute(bus)
		Save.data.audio_buses[audio_bus_name] = {
			"default_volume": bus_volume,
			"default_muted": is_bus_mute,
			"volume": bus_volume,
			"muted": is_bus_mute,
		}
	var volume = Save.data.audio_buses[audio_bus_name]["volume"]
	volume_slider.value = volume
	AudioServer.set_bus_volume_db(bus, linear2db(volume))
	var muted = Save.data.audio_buses[audio_bus_name]["muted"]
	default_mute = Save.data.audio_buses[audio_bus_name]["default_muted"]
	default_volume = Save.data.audio_buses[audio_bus_name]["default_volume"]
	mute.pressed = muted
	_on_Mute_toggled(muted)
	AudioServer.set_bus_mute(bus, muted)
	set_reset_show()


# Updates Save mute
# Sets bus mute value
func _on_Mute_toggled(button_pressed : bool) -> void:
	if button_pressed:
		mute_icon.texture = preload("res://assets/ui/mute.png")
	else:
		mute_icon.texture = preload("res://assets/ui/speaker.png")
	set_reset_show()
	Save.data.audio_buses[audio_bus_name]["muted"] = button_pressed
	AudioServer.set_bus_mute(bus, button_pressed)


# Resets volume to default values
func reset() -> void:
	volume_slider.value = Save.data.audio_buses[audio_bus_name]["default_volume"]
	mute.pressed = Save.data.audio_buses[audio_bus_name]["default_muted"]
	set_reset_show()


# Sets default and reset.visible based on if the values are at default.
func set_reset_show() -> void:
	if mute.pressed == default_mute && volume_slider.value == default_volume:
		is_default = true
		reset.hide()
	else:
		is_default = false
		reset.show()
	emit_signal("updated")
