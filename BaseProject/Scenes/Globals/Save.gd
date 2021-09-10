extends Node

const SAVE_DIR = "user://saves/"

var save_path = SAVE_DIR + "save.txt"
var data

func _ready() -> void:
	load_data()
	get_tree().call_group("save", "load_data")


func load_data() -> void:
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open(save_path, File.READ)
		if error == OK:
			data = file.get_var()
		file.close()
	else:
		data = {}


func save_data() -> void:
	var dir = Directory.new()
	if not dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	
	var file = File.new()
	var error = file.open(save_path, File.WRITE)
	if error == OK:
		file.store_var(data)
	file.close()


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		save_data()
		get_tree().quit()
