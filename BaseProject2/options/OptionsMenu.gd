extends CanvasLayer

var active : bool = false setget set_active

onready var mouse_capture := $MouseCapture


# Toggles option menu on "pause" press.
func _input(event):
	if event.is_action_released("pause"):
		self.active = not active
		get_tree().set_input_as_handled()


# Sets the active of the option menu.
func set_active(val) -> void:
	active = val
	$M.visible = val
	mouse_capture.visible = val
	get_tree().paused = val
