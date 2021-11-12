extends CanvasLayer

onready var tab_container := $M/TabContainer
onready var mouse_capture := $MouseCapture

var active = false setget set_active

# Toggles option menu on "pause" press
func _input(event):
	if event is InputEventKey:
		if event.is_pressed():
			for i in InputMap.get_action_list("pause"):
				if event.scancode == i.scancode:
					self.active = not active
					break

# Sets tab to options.
func _on_Button_pressed():
	tab_container.current_tab = 0

# Sets tab to audio settings.
func _on_Audio_pressed():
	tab_container.current_tab = 1

# Sets tab to control remapping.
func _on_Controls_pressed():
	tab_container.current_tab = 2

# Sets tab to screen settings.
func _on_ScreenSettings_pressed():
	tab_container.current_tab = 3

# Closes option menu.
func _on_Back_pressed():
	set_active(false)

# Sets the active of the option menu.
func set_active(val) -> void:
	tab_container.current_tab = 0
	active = val
	$M.visible = val
	mouse_capture.visible = val
	get_tree().paused = val

# Closes option menu.
func _on_Menu_pressed():
	set_active(false)
