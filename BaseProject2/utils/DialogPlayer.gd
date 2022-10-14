extends Control

signal dialog_finished

const READ_SPEED : float = 30.0

export(bool) var autoplay := false
export(AudioStream) var default_audio
export(Color) var default_color = Color.white
export(Array, String, MULTILINE) var autoplay_dialog := []

var dialogs : Array
var d_ind : int
var reading : bool = false
var has_dialog : bool = false
var curr_text : String = ""

onready var t := $Tween
onready var label := $M/ColorRect/M/Label
onready var text_sfx := $TextSFX


func _ready() -> void:
	if autoplay:
		read(autoplay_dialog)


func read(d: Array, color: Color = default_color,
		sfx: AudioStream = default_audio) -> void:
	if d.empty():
		d = ["..."]
	if not sfx:
		sfx = default_audio
	label.modulate = color
	text_sfx.stream = sfx
	label.percent_visible = 0
	has_dialog = true
	call_deferred("show")
	d_ind = -1
	dialogs = d
	read_next()


func read_next() -> void:
	d_ind += 1
	if d_ind >= dialogs.size():
		has_dialog = false
		emit_signal("dialog_finished")
		text_sfx.stop()
		hide()
		return
	text_sfx.play()
	curr_text = dialogs[d_ind]
	label.text = dialogs[d_ind].format(Variables.input_format)
	var cc = label.get_total_character_count()
	t.interpolate_property(label, "percent_visible", 0, 1, cc/READ_SPEED)
	t.start()
	reading = true


func stop() -> void:
	reading = false
	has_dialog = false
	t.remove_all()
	text_sfx.stop()
	hide()


func update_keys():
	label.text = curr_text.format(Variables.input_format)


func _gui_input(event: InputEvent) -> void:
	if has_dialog:
		if event is InputEventMouseButton:
			if not event.is_pressed():
				match event.button_index:
					1, 2:
						if reading:
							t.remove_all()
							label.percent_visible = 1.0
							reading = false
							text_sfx.stop()
						else:
							read_next()
						accept_event()


func _on_Tween_tween_all_completed() -> void:
	reading = false
	text_sfx.stop()
