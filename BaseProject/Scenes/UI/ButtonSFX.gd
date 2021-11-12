extends Button
class_name ButtonSFX
# warnings-disable

# Connects mouse_entered signal to play hover sfx.
func _ready() -> void:
	connect("mouse_entered", self, "_play_hover_sfx")

# Plays SFX on press.
func _pressed() -> void:
	var sfx := AudioStreamPlayer.new()
	sfx.bus = "SFX"
	sfx.stream = preload("res://Assets/SFX/OptionsSelect.mp3")
	sfx.pause_mode = Node.PAUSE_MODE_PROCESS
	sfx.volume_db = -15
	add_child(sfx)
	sfx.play()
	sfx.connect("finished", sfx, "queue_free")

# Plays SFX on hover.
func _play_hover_sfx() -> void:
	var sfx := AudioStreamPlayer.new()
	sfx.bus = "SFX"
	sfx.stream = preload("res://Assets/SFX/OptionsHover.mp3")
	sfx.pause_mode = Node.PAUSE_MODE_PROCESS
	sfx.volume_db = -15
	add_child(sfx)
	sfx.play()
	sfx.connect("finished", sfx, "queue_free")
