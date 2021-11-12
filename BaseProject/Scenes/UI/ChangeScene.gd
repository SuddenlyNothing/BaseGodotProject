extends ButtonSFX
class_name ChangeScene

export(String, FILE, "*.tscn") var next_scene

# Changes scene to next_scene
func _pressed() -> void:
	if get_path() == "/root/OptionsMenu/M/TabContainer/OptionSelect/M/V/V2/Menu":
		assert(next_scene != "", "You have not set the menu scene. Follow bellow instructions to fix."+
			"\nOpen OptionsMenu.tscn. Click on Filter nodes in the scene tree and type in 'Menu'."+
			"\nSelect the Menu node and set the next_scene property by clicking on the folder icon.")
	else:
		assert(next_scene != "", "The pressed node does not have a valid filepath."+
			"\nPlease set the next_scene property for this button.")
	Global.goto_scene(next_scene)
	._pressed()
