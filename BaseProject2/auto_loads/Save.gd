extends Node

const SAVE_DIR = "user://saves/"

var settings_save_path = SAVE_DIR + "settings.dat"
var data


# Loads data of all nodes that are in group "save".
func _ready() -> void:
	load_data()
	get_tree().call_group("save", "load_data")


# Loads data from folder if the folder filepath exists.
func load_data() -> void:
	var file = File.new()
	if file.file_exists(settings_save_path):
		var error = file.open(settings_save_path, File.READ)
		if error == OK:
			data = file.get_var(true)
		file.close()
	else:
		data = {}


# Saves data to folder filepath.
func save_data() -> void:
	var dir = Directory.new()
	if not dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	
	var file = File.new()
	var error = file.open(settings_save_path, File.WRITE)
	if error == OK:
		file.store_var(data, true)
	file.close()


# Handles saving when the game is closed.
# If you want to quit the game through a quit button, use this:
# get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST).
func _notification(what: int) -> void:
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		save_data()
