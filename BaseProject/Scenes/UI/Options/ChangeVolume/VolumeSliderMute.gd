tool
extends HBoxContainer

export(String, "Master", "SFX", "Music") var audio_bus_name : String = "Master" setget set_audio_bus_name

onready var bus : int = AudioServer.get_bus_index(audio_bus_name)
onready var mute := $H/Mute
onready var volume_slider := $VolumeSlider

# Sets the label to the audio bus name
func set_audio_bus_name(val : String) -> void:
	audio_bus_name = val
	$H/BusLabel.text = val

# Updates save data as well as bus volume
func _on_VolumeSlider_value_changed(value : float) -> void:
	Save.data[audio_bus_name]["volume"] = value
	AudioServer.set_bus_volume_db(bus, linear2db(value))

# Loads data from Save singleton
# Called from Save _ready
# Called because in the save group
func load_data() -> void:
	if not audio_bus_name in Save.data:
		Save.data[audio_bus_name] = {}
		Save.data[audio_bus_name]["volume"] = db2linear(AudioServer.get_bus_volume_db(bus))
		Save.data[audio_bus_name]["muted"] = false
	var volume = Save.data[audio_bus_name]["volume"]
	volume_slider.value = volume
	AudioServer.set_bus_volume_db(bus, linear2db(volume))
	var muted = Save.data[audio_bus_name]["muted"]
	mute.pressed = muted
	AudioServer.set_bus_mute(bus, muted)

# Updates Save mute
# Sets bus mute value
func _on_Mute_toggled(button_pressed : bool) -> void:
	if button_pressed:
		mute.icon = preload("res://Assets/UI/VolumeIconMute.png")
	else:
		mute.icon = preload("res://Assets/UI/VolumeIcon.png")
	Save.data[audio_bus_name]["muted"] = button_pressed
	AudioServer.set_bus_mute(bus, button_pressed)

# Resets volume to max and unmutes
func reset() -> void:
	volume_slider.value = 1
	mute.pressed = false
