extends VBoxContainer

const VolumeModule := preload("res://options/VolumeSettings/VolumeModule.tscn")

# Will load audio bus data from this array if not empty
const AUDIO_BUSES : Array = []


func _ready():
	load_volume_modules()


func load_volume_modules() -> void:
	if AUDIO_BUSES.empty():
		for i in AudioServer.bus_count:
			load_module(AudioServer.get_bus_name(i))
	else:
		for i in AUDIO_BUSES:
			load_module(i)


func load_module(bus_name: String) -> void:
	var volume_module = VolumeModule.instance()
	add_child(volume_module)
	volume_module.audio_bus_name = bus_name


func _on_ResetAll_pressed() -> void:
	for i in range(1, get_child_count()):
		get_child(i).reset()
