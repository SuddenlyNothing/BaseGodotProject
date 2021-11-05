extends Control

# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
# NOTE: Will erase mouse inputs on load after save and reset!!
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

var InputRemapButton := preload("res://Scenes/UI/Options/InputRemap/InputRemapButton.tscn")
var InputRemapModule := preload("res://Scenes/UI/Options/InputRemap/InputRemapModule.tscn")

onready var v_box := $V/SC/V

# Sets up input remap buttons and modules based on user_keys from
# the Variables singleton
func get_load_user_keys(actions:PoolStringArray) -> void:
	for action in actions:
		var input_remap_module = InputRemapModule.instance()
		input_remap_module.get_child(0).text = action.replace("_", " ")
		v_box.add_child(input_remap_module)
		for input in InputMap.get_action_list(action):
			if not input is InputEventKey:
				continue
			var input_remap_button = InputRemapButton.instance()
			input_remap_button.init(action, input.scancode)
			input_remap_module.add_child(input_remap_button)
	load_input_format()

# Loads input data from Save.
func load_data() -> void:
	if "actions" in Save.data:
		for action in Save.data.actions:
			InputMap.action_erase_events(action)
			for scancode in Save.data.actions[action]:
				var new_key = InputEventKey.new()
				new_key.scancode = scancode
				InputMap.action_add_event(action, new_key)
	else:
		Save.data["actions"] = {}
		for action in Variables.user_keys:
			Save.data.actions[action] = []
			for key in InputMap.get_action_list(action):
				if not key is InputEventKey:
					continue
				Save.data.actions[action].append(key.scancode)
		Save.data["default_keys"] = Save.data.actions.duplicate(true)
	get_load_user_keys(Variables.user_keys)

# Resets controls to default.
func _on_Reset_pressed():
	Save.data.actions = Save.data.default_keys.duplicate(true)
	for action in Save.data.default_keys:
		InputMap.action_erase_events(action)
		for scancode in Save.data.default_keys[action]:
			var new_key = InputEventKey.new()
			new_key.scancode = scancode
			InputMap.action_add_event(action, new_key)
	for child in v_box.get_children():
		child.queue_free()
	get_load_user_keys(Variables.user_keys)

# Sets input_format for Variables
func load_input_format() -> void:
	for action in Variables.user_keys:
		Variables.input_format[action] = ""
		for key in InputMap.get_action_list(action):
			if not key is InputEventKey:
				continue
			if Variables.input_format[action] == "":
				Variables.input_format[action] = "'" + OS.get_scancode_string(key.scancode) + "'"
			else:
				Variables.input_format[action] += " or '" + OS.get_scancode_string(key.scancode) + "'"
	get_tree().call_group("uses_keys", "update_keys")
