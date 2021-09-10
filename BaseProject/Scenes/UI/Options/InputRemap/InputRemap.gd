extends Control

# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
# NOTE: Will erase mouse inputs on load after save!! <- <- <-
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

var InputRemapButton := preload("res://Scenes/UI/Options/InputRemap/InputRemapButton.tscn")
var InputRemapModule := preload("res://Scenes/UI/Options/InputRemap/InputRemapModule.tscn")

onready var v_box := $SC/V/V

export(PoolStringArray) var user_keys = PoolStringArray(["debug", "up", "left", "down", "right"])

#func _ready() -> void:
#	get_load_user_keys(user_keys)


func get_load_user_keys(actions:Array) -> void:
	for action in actions:
		var input_remap_module = InputRemapModule.instance()
		v_box.add_child(input_remap_module)
		input_remap_module.get_child(0).text = action
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
			prints(action, Save.data.actions[action])
			for scancode in Save.data.actions[action]:
				var new_key = InputEventKey.new()
				new_key.scancode = scancode
				InputMap.action_add_event(action, new_key)
	else:
		Save.data["actions"] = {}
		for action in user_keys:
			print(action)
			Save.data.actions[action] = []
			for key in InputMap.get_action_list(action):
				if not key is InputEventKey:
					continue
				Save.data.actions[action].append(key.scancode)
	get_load_user_keys(user_keys)


#var inputs_to_action = {}
#var keys_in_order = []

#func get_user_keys() -> void:
#	inputs_to_action = {}
#	var actions = InputMap.get_actions()
#	for action in actions:
#		if "ui_" in action:
#			continue
#		var action_list = InputMap.get_action_list(action)
#		for input_event in action_list:
#			if not input_event is InputEventKey:
#				break
#			if not action in inputs_to_action:
#				inputs_to_action[action] = []
#				keys_in_order.append(action)
#			inputs_to_action[action].append(input_event.scancode)
#	keys_in_order.sort()
#
#
#func load_user_keys() -> void:
#	for key in keys_in_order:
#		var input_remap_module = InputRemapModule.instance()
#		v_box.add_child(input_remap_module)
#		input_remap_module.get_child(0).text = key
#		for input in inputs_to_action[key]:
#			var input_remap_button = InputRemapButton.instance()
#			input_remap_button.init(key, input)
#			input_remap_module.add_child(input_remap_button)
