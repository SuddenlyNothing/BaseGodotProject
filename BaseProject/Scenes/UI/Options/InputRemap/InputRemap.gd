extends Control

# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
# NOTE: Will erase mouse inputs on load after save and reset!! <- <- <-
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

var InputRemapButton := preload("res://Scenes/UI/Options/InputRemap/InputRemapButton.tscn")
var InputRemapModule := preload("res://Scenes/UI/Options/InputRemap/InputRemapModule.tscn")

onready var v_box := $V/SC/V

export(PoolStringArray) var user_keys = PoolStringArray(["debug", "up", "left", "down", "right"])

#func _ready() -> void:
#	get_load_user_keys(user_keys)


func get_load_user_keys(actions:Array) -> void:
	for action in actions:
		var input_remap_module = InputRemapModule.instance()
		input_remap_module.get_child(0).text = action
		v_box.add_child(input_remap_module)
		for input in InputMap.get_action_list(action):
			if not input is InputEventKey:
				continue
			var input_remap_button = InputRemapButton.instance()
			input_remap_button.init(action, input.scancode)
			input_remap_module.add_child(input_remap_button)


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
		for action in user_keys:
			Save.data.actions[action] = []
			for key in InputMap.get_action_list(action):
				if not key is InputEventKey:
					continue
				Save.data.actions[action].append(key.scancode)
		Save.data["default_keys"] = Save.data.actions.duplicate(true)
	get_load_user_keys(user_keys)


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
	get_load_user_keys(user_keys)
