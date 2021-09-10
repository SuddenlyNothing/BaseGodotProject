extends Control

onready var v1 := $V/V/H/VolumeSlider
onready var v2 := $V/V/H2/VolumeSlider
onready var v3 := $V/V/H3/VolumeSlider

func _on_Reset_pressed():
	v1.value = 100
	v2.value = 100
	v3.value = 100
