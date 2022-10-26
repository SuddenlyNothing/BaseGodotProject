extends Control

signal dialog_finished

const READ_SPEED : float = 30.0
const PAUSE_SYMBOLS := {
	".": 13,
	",": 5,
	":": 5,
	"!": 13,
	"?": 13,
	";": 10,
}

export(bool) var autoplay := false
export(AudioStream) var default_audio
export(Color) var default_color = Color.white
export(String) var empty_dialog := "..."
export(Array, String, MULTILINE) var autoplay_dialog := []

var dialogs: Array
var d_ind: int
var reading: bool = false
var has_dialog: bool = false
var curr_text: String = ""
var t: SceneTreeTween

onready var label := $"%Label"
onready var text_sfx := $TextSFX


func _ready() -> void:
	if autoplay:
		read(autoplay_dialog)


func _gui_input(event: InputEvent) -> void:
	if has_dialog:
		if event.is_action_pressed("continue", false, false):
			if reading:
				t.kill()
				label.percent_visible = 1.0
				reading = false
				text_sfx.stop()
			else:
				read_next()
			accept_event()


func read(d: Array, color: Color = default_color,
		sfx: AudioStream = default_audio) -> void:
	if not sfx:
		sfx = default_audio
	label.modulate = color
	text_sfx.stream = sfx
	has_dialog = true
	d_ind = -1
	dialogs = d
	read_next()
	call_deferred("show")


func read_next() -> void:
	d_ind += 1
	if d_ind >= dialogs.size():
		has_dialog = false
		emit_signal("dialog_finished")
		text_sfx.stop()
		hide()
		return
	label.percent_visible = 0
	text_sfx.play()
	curr_text = dialogs[d_ind]
	var new_dialog: String = dialogs[d_ind].format(Variables.input_format)
	if len(new_dialog) <= 0:
		new_dialog = empty_dialog
	label.text = new_dialog
	
	var new_dialog_spaceless := new_dialog.replace(" ", "")
	var dialog_len := len(new_dialog_spaceless)
	var curr_percent_visible := 0.0
	var max_delay := 0.0
	var has_pause := false
	t = create_tween()
	for i in dialog_len:
		var curr_char := new_dialog_spaceless[i]
		if curr_char in PAUSE_SYMBOLS:
			has_pause = true
			max_delay = max(max_delay, PAUSE_SYMBOLS[curr_char])
		elif has_pause:
			has_pause = false
			var new_percent_visible := float(i) / dialog_len
			t.tween_property(label, "percent_visible",
					new_percent_visible, floor((new_percent_visible - \
					curr_percent_visible) * dialog_len) / READ_SPEED)
			t.tween_callback(text_sfx, "stop")
			t.tween_interval(max_delay / READ_SPEED)
			t.tween_callback(text_sfx, "play")
			curr_percent_visible = new_percent_visible
			max_delay = 0.0
	t.tween_property(label, "percent_visible", 1.0,
			(1 - curr_percent_visible) * dialog_len / READ_SPEED)
	t.tween_callback(self, "stop_reading")
	
	reading = true


func stop() -> void:
	reading = false
	has_dialog = false
	t.kill()
	text_sfx.stop()
	hide()


func update_keys():
	label.text = curr_text.format(Variables.input_format)


func stop_reading() -> void:
	reading = false
	text_sfx.stop()
