extends ButtonSFX
# warnings-disable

var action : String
var scancode : int

# Turns off _input method.
# No longer detects inputs.
func _ready() -> void:
	set_process_input(false)

# Sets this button's action and scancode.
func init(action, scancode) -> void:
	self.action = action
	self.scancode = scancode
	
	text = OS.get_scancode_string(scancode)

# Turns on _input method.
func _on_InputRemapButton_toggled(button_pressed) -> void:
	set_process_input(button_pressed)

# Detects Key events and changes key mapping based on the
# pressed key.
# Will turn off if the MouseButton is pressed.
func _input(event) -> void:
	if event is InputEventMouseButton:
		pressed = false
	if event is InputEventKey:
		if event.scancode == scancode:
			pressed = false
			accept_event()
			return
		for i in InputMap.get_action_list(action):
			if not i is InputEventKey:
				continue
			if i.scancode == event.scancode:
				pressed = false
				accept_event()
				return
		change_to_scancode(event.scancode)
		pressed = false
		event.set_pressed(false)
		accept_event()

# Updates InputMap as well as label to new_scancode
func change_to_scancode(new_scancode) -> void:
	var old_key = InputEventKey.new()
	old_key.scancode = scancode
	InputMap.action_erase_event(action, old_key)
	Save.data.actions[action].erase(scancode)
	
	var new_key = InputEventKey.new()
	new_key.scancode = new_scancode
	InputMap.action_add_event(action, new_key)
	text = OS.get_scancode_string(new_scancode)
	scancode = new_scancode
	Save.data.actions[action].append(scancode)
	update_input_format(action)


func update_input_format(update_action : String) -> void:
	var new_format_string = ""
	for i in InputMap.get_action_list(update_action):
		if new_format_string == "":
			new_format_string += "'" + OS.get_scancode_string(i.scancode) + "'"
		else:
			new_format_string += " or " + "'" + OS.get_scancode_string(i.scancode) + "'"
	Variables.input_format[update_action] = new_format_string
	get_tree().call_group("uses_keys", "update_keys")
