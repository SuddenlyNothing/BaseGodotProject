extends Control

onready var v1 := $V/V/VolumeSliderMute
onready var v2 := $V/V/VolumeSliderMute2
onready var v3 := $V/V/VolumeSliderMute3


func _on_Reset_pressed():
	v1.reset()
	v2.reset()
	v3.reset()
