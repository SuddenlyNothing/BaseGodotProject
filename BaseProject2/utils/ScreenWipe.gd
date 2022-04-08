extends ColorRect

signal faded_in
signal faded_out

onready var fade_in_t := $FadeIn
onready var fade_out_t := $FadeOut

var fade_duration := 0.2


# Called for the initial fade in on game start.
func _ready() -> void:
	fade_in()


# Fades in.
func fade_in() -> void:
	fade_in_t.interpolate_property(self, "modulate:a", 1, 0, fade_duration)
	fade_in_t.start()
	yield(fade_in_t, "tween_all_completed")
	emit_signal("faded_in")


# Fades out.
func fade_out() -> void:
	fade_out_t.interpolate_property(self, "modulate:a", 0, 1, fade_duration)
	fade_out_t.start()
	yield(fade_out_t, "tween_all_completed")
	emit_signal("faded_out")
