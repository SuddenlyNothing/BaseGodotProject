class_name ButtonSFX
extends Button
# warnings-disable

# Connects mouse_entered signal to play hover sfx.
func _ready() -> void:
	connect("mouse_entered", self, "_play_hover_sfx")


# Plays SFX on press.
func _pressed() -> void:
	var sfx := AudioStreamPlayer.new()
	sfx.bus = "SFX"
	sfx.stream = preload("res://assets/sfx/OptionsSelect.wav")
	sfx.pause_mode = Node.PAUSE_MODE_PROCESS
	sfx.volume_db = -15
	add_child(sfx)
	sfx.play()
	sfx.connect("finished", sfx, "queue_free")


# Plays SFX on hover.
func _play_hover_sfx() -> void:
	if disabled:
		return
	var sfx := AudioStreamPlayer.new()
	sfx.bus = "SFX"
	sfx.stream = preload("res://assets/sfx/OptionsHover.wav")
	sfx.pause_mode = Node.PAUSE_MODE_PROCESS
	sfx.volume_db = -20
	add_child(sfx)
	sfx.play()
	sfx.connect("finished", sfx, "queue_free")
