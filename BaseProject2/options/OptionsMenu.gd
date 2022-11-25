extends CanvasLayer

var active : bool = false setget set_active
var previous_focus: Control

onready var open_sfx := $OpenSFX
onready var ui := get_child(0)


# Toggles option menu on "pause" press.
func _input(event: InputEvent) -> void:
	if event.is_action_released("pause"):
		self.active = not active
		get_tree().set_input_as_handled()


# Sets the active of the option menu.
func set_active(val: bool) -> void:
	active = val
	visible = val
	get_tree().paused = val
	open_sfx.play()
	ui.set_focus_button_active(val)
