extends CanvasLayer

var active : bool = false setget set_active

onready var options_ui := get_child(0)


# Toggles option menu on "pause" press.
func _input(event):
	if event.is_action_released("pause"):
		self.active = not active
		get_tree().set_input_as_handled()
		
		# Play click sfx
		var sfx := AudioStreamPlayer.new()
		sfx.bus = "SFX"
		sfx.stream = preload("res://assets/sfx/OptionsSelect.wav")
		sfx.pause_mode = Node.PAUSE_MODE_PROCESS
		sfx.volume_db = -15
		add_child(sfx)
		sfx.play()
		sfx.connect("finished", sfx, "queue_free")


# Sets the active of the option menu.
func set_active(val) -> void:
	active = val
	options_ui.visible = val
	get_tree().paused = val
