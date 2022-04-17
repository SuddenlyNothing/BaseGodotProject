extends VBoxContainer

const InputRemapModule := preload("res://options/input_remap/"+
		"InputRemapModule.tscn")

# Translates button constants to strings.
const MOUSE_BUTTONS = {
	BUTTON_LEFT: "BUTTON_LEFT", # Left mouse button.
	BUTTON_RIGHT: "BUTTON_RIGHT", # Right mouse button.
	BUTTON_MIDDLE: "BUTTON_MIDDLE", # Middle mouse button.
	BUTTON_XBUTTON1: "BUTTON_XBUTTON1", # Extra mouse button 1
	BUTTON_XBUTTON2: "BUTTON_XBUTTON2", # Extra mouse button 2
	BUTTON_WHEEL_UP: "BUTTON_WHEEL_UP", # Mouse wheel up.
	BUTTON_WHEEL_DOWN: "BUTTON_WHEEL_DOWN", # Mouse wheel down.
	BUTTON_WHEEL_LEFT: "BUTTON_WHEEL_LEFT", # Mouse wheel left button
	BUTTON_WHEEL_RIGHT: "BUTTON_WHEEL_RIGHT", # Mouse wheel right button
}

# Used for determining key button font size
const BUTTON_H_CONTENT_MARGIN : int = 30
const DEFAULT_FONT_SIZE : int = 28

# Font used for buttons
export(String, FILE, "*.ttf") var font_path : String

# True when a key is being remapped
var is_mapping : bool = false
# Button being remapped set on remap button pressed
var map_key_button := {
	"self": null,
	"parent": null,
	"action": null,
	"ind": null,
}

# Reset buttons for storing action, parent, and reset buttons
# Used for resetting inputs for actions and determining visibility
var reset_buttons = {}

onready var reset_all := $ResetAll


# Called by the Save singleton
# Loads keys from Variables.user_keys if no data (no saves yet)
func load_data() -> void:
	if "actions" in Save.data:
		for action in Save.data.actions:
			add_new_input_remap_module(action, Save.data.actions[action].inputs)
	else:
		Save.data["actions"] = {}
		for action in Variables.user_keys:
			add_new_input_remap_module(action,
					InputMap.get_action_list(action), false)
	set_reset_all_disabled()


# Maps new inputs to actions using map_key_button
func _input(event: InputEvent) -> void:
	if is_mapping:
		if can_map_event(event):
			map_key_button.self.text = input_to_text(event)
			var action_inputs : Array = Save.data.actions[map_key_button\
					.action].inputs
			var old_event : InputEvent = action_inputs[map_key_button.ind]
			# replace old event
			action_inputs[map_key_button.ind] = event
			# Map action to new event
			InputMap.action_erase_event(map_key_button.action, old_event)
			InputMap.action_add_event(map_key_button.action, event)
			# Set font size
			set_key_button_font_size(map_key_button.self, input_to_text(event))
			# Reset mapping state.
			is_mapping = false
			map_key_button.self.pressed = false
			# Sets reset buttons
			set_reset_visible(map_key_button.action)
			set_reset_all_disabled()
			# Update input format
			update_action_format(map_key_button.action)
		# Eat inputs so it doesn't propogate further
		get_tree().set_input_as_handled()


# Adds an input remap module as a child
# {action} is the action the module is representing
# {events} are the events that can be remapped
# {from_save} is if the provided action and events are from save data
func add_new_input_remap_module(action: String, events: Array,
		from_save: bool = true) -> void:
	var input_remap_module = InputRemapModule.instance()
	input_remap_module.get_node("H/Label").text = action.capitalize()
	var input_reset_button = input_remap_module.get_node("H/Reset")
	var buttons_parent = input_remap_module.get_node("V")
	reset_buttons[action] = [input_reset_button, buttons_parent]
	input_reset_button.connect("pressed", self, "_on_reset_pressed", [action])
	InputMap.action_erase_events(action)
	if not from_save:
		Save.data.actions[action] = {
			"default_inputs": [],
			"inputs": [],
		}
	
	for i in events.size():
		if not from_save:
			Save.data.actions[action].inputs.append(events[i])
			Save.data.actions[action].default_inputs.append(events[i])
		InputMap.action_add_event(action, events[i])
		add_new_key_button(buttons_parent, events[i], action, i)
	
	# Update input format
	update_action_format(action)
	add_child(input_remap_module)
	
	set_reset_visible(action)


# Adds a key button to the given parent
# {event} is InputEvent this button is representing
# {action} is the InputMap action that this button is a part of
# {button_ind} is the index of the button. Useful for indexing against
func add_new_key_button(parent: Node, event: InputEvent, action: String,
		button_ind: int) -> void:
	var key_button := ButtonSFX.new()
	key_button.text = input_to_text(event)
	key_button.toggle_mode = true
	key_button.clip_text = true
	key_button.connect("pressed", self, "_on_key_button_pressed",
			[parent, key_button, action, button_ind])
	parent.add_child(key_button)
	yield(key_button, "draw")
	key_button.rect_min_size = key_button.rect_size
	set_key_button_font_size(key_button, input_to_text(event))


# Update font size to fit text within button
func set_key_button_font_size(key_button: ButtonSFX, text: String) -> void:
	var font : DynamicFont = key_button.get_font("")
	var content_size = key_button.rect_size.x - BUTTON_H_CONTENT_MARGIN
	var font_lines = font.get_string_size(text).x / content_size
	# Couldn't find a better way to change font size for single button
	var new_font = DynamicFont.new()
	var new_data = DynamicFontData.new()
	var new_font_size : int = floor(min(font.size / font_lines,
			DEFAULT_FONT_SIZE))
	new_data.font_path = font_path
	new_font.font_data = new_data
	new_font.size = new_font_size
	key_button.set("custom_fonts/font", new_font)


# Updates the input_format in Variables to match the actual keys
func update_action_format(action: String) -> void:
	var action_list := InputMap.get_action_list(action)
	var all_actions = ""
	for i in action_list.size():
		if i > 0:
			if action_list.size() != 2:
				all_actions += ", "
			else:
				all_actions += " "
			if i == action_list.size() - 1:
				all_actions += "or "
		all_actions += input_to_text(action_list[i])
	Variables.input_format[action] = all_actions
	get_tree().call_group("needs_keys", "update_keys")


# Checks if children of parent with the action child has the default inputs
func is_children_defaults(parent, action: String) -> bool:
	var inputs = []
	for i in Save.data.actions[action].default_inputs:
		inputs.append(input_to_text(i))
	for i in parent.get_children():
		if not i.text in inputs:
			return false
	return true


# Check if event is mappable.
# (e.g. an actual keypress, joypad input or mouse click)
func can_map_event(event: InputEvent) -> bool:
	# some events can't be mapped to actions
	if not event.is_action_type():
		return false
	
	# wait for button release (this allows for key modifiers)
	if event.is_pressed():
		return false
	
	# threshold for JoyPad-Axis 
	if event is InputEventJoypadMotion:
		return abs((event as InputEventJoypadMotion).axis_value) > 0.3
	
	return true


# Takes an input and returns it as text.
func input_to_text(input: InputEvent) -> String:
	if input is InputEventMouseButton:
		return MOUSE_BUTTONS[input.button_index]
		
	if input is InputEventJoypadButton:
		return "Joypad Button %d" % input.button_index
		
	if input is InputEventJoypadMotion:
		return "Joypad Axis %d%s" % [input.axis,
				"+" if input.axis_value > 0 else "-"]
	
	return input.as_text()


# Resets inputs of the given action to saved defaults
func reset_action(action: String) -> void:
	reset_buttons[action][0].hide()
	var buttons_parent = reset_buttons[action][1]
	InputMap.action_erase_events(action)
	for i in buttons_parent.get_child_count():
		var default_input = Save.data.actions[action].default_inputs[i]
		var button = buttons_parent.get_child(i)
		button.text = input_to_text(default_input)
		set_key_button_font_size(button, button.text)
		Save.data.actions[action].inputs[i] = default_input
		InputMap.action_add_event(action, default_input)
	update_action_format(action)


# Sets the reset button's visibility based on if children are default
func set_reset_visible(action: String) -> void:
	if is_children_defaults(reset_buttons[action][1], action):
		reset_buttons[action][0].hide()
	else:
		reset_buttons[action][0].show()


# Resets inputs of the given action and updates disiability of reset_all
func _on_reset_pressed(action: String) -> void:
	reset_action(action)
	set_reset_all_disabled()


# Sets disabled if all actions are at defaults
func set_reset_all_disabled() -> void:
	for i in reset_buttons:
		if not is_children_defaults(reset_buttons[i][1], i):
			reset_all.disabled = false
			return
	reset_all.disabled = true


# Sets the mapping state to active starts the input detection
func _on_key_button_pressed(parent: Node, key_button: ButtonSFX, action: String,
		button_ind: int) -> void:
	if not key_button.pressed:
		return
	is_mapping = true
	map_key_button.self = key_button
	map_key_button.parent = parent
	map_key_button.action = action
	map_key_button.ind = button_ind
	key_button.text = "..."
	set_key_button_font_size(key_button, "...")


# Resets all actions to default inputs
func _on_ResetAll_pressed() -> void:
	for i in reset_buttons:
		reset_action(i)
	reset_all.disabled = true
