extends Button

var action
var scancode

func _ready():
	set_process_input(false)
#	init("up", OS.find_scancode_from_string("w"))

func init(action, scancode) -> void:
	self.action = action
	self.scancode = scancode
	
	text = OS.get_scancode_string(scancode)


func _on_InputRemapButton_toggled(button_pressed):
	set_process_input(button_pressed)


func _input(event) -> void:
	if event is InputEventMouseButton:
		pressed = false
	if event is InputEventKey:
		if event.scancode == scancode:
			pressed = false
			return
		for i in InputMap.get_action_list(action):
			if not i is InputEventKey:
				continue
			if i.scancode == event.scancode:
				pressed = false
				return
		var old_key = InputEventKey.new()
		old_key.scancode = scancode
		InputMap.action_erase_event(action, old_key)
		Save.data.actions[action].erase(scancode)
		
		InputMap.action_add_event(action, event)
		text = OS.get_scancode_string(event.scancode)
		scancode = event.scancode
		Save.data.actions[action].append(scancode)
		pressed = false
		
#		print(action)
#		for i in InputMap.get_action_list(action):
#			if not i is InputEventKey:
#				continue
#			prints(OS.get_scancode_string(i.scancode), i)
	
