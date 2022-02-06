extends CanvasLayer

var active : bool = false setget set_active

onready var mouse_capture := $MouseCapture


# Toggles option menu on "pause" press.
func _input(event):
	if event is InputEventKey:
		if event.is_pressed() and not event.is_echo():
			for i in InputMap.get_action_list("pause"):
				if event.scancode == i.scancode:
					self.active = not active
					break


# Sets the active of the option menu.
func set_active(val) -> void:
	active = val
	$M.visible = val
	mouse_capture.visible = val
	get_tree().paused = val
