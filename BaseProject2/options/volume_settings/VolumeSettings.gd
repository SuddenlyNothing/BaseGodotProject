extends VBoxContainer

const VolumeModule := preload("res://options/volume_settings/VolumeModule.tscn")

# Will load audio bus data from this array if not empty.
const AUDIO_BUSES : Array = []

onready var reset_all := $ResetAll


# Called from Save singleton and loads the audio buses from save data or from
# AUDIO_BUSES or directly from AudioServer.
func load_data() -> void:
	if "audio_buses" in Save.data:
		for audio_bus in Save.data.audio_buses:
			load_module(audio_bus)
	else:
		Save.data["audio_buses"] = {}
		if AUDIO_BUSES.empty():
			for i in AudioServer.bus_count:
				load_module(AudioServer.get_bus_name(i))
		else:
			for i in AUDIO_BUSES:
				load_module(i)


# Adds a child VolumeModule with the given bus_name.
func load_module(bus_name: String) -> void:
	var volume_module = VolumeModule.instance()
	volume_module.connect("updated", self, "_on_volume_module_updated")
	add_child(volume_module)
	volume_module.audio_bus_name = bus_name


# Resets all child VolumeModules to default values.
func _on_ResetAll_pressed() -> void:
	for i in range(1, get_child_count()):
		get_child(i).reset()


# Sets reset_all to disabled if all child VolumeModules are at default values.
func _on_volume_module_updated() -> void:
	for i in range(1, get_child_count()):
		if not get_child(i).is_default:
			reset_all.disabled = false
			return
	reset_all.disabled = true
