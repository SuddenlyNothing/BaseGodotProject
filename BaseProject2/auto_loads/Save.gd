extends Node

const SAVE_DIR := "user://saves/"

var settings_save_path := SAVE_DIR + "settings.tres"
var data : SaveData


# Loads data of all nodes that are in group "save".
func _ready() -> void:
	load_data()
	get_tree().call_group("save", "load_data")


# Loads data from folder if the folder filepath exists.
func load_data() -> void:
	if ResourceLoader.exists(settings_save_path):
		data = load(settings_save_path)
		data.loaded = true
	else:
		data = SaveData.new()


# Saves data to folder filepath.
func save_data() -> void:
	var dir = Directory.new()
	if not dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	
	if data:
		# warning-ignore:return_value_discarded
		ResourceSaver.save(settings_save_path, data)


# Handles saving when the game is closed.
# If you want to quit the game through a quit button, use this:
# get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST).
func _notification(what: int) -> void:
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		save_data()
