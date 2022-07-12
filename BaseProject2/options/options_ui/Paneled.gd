extends Control

onready var settings_manager := $M/V
onready var pressed_sfx := $PressedSFX


func _on_ColorRect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1 and not event.is_pressed():
			settings_manager._on_Back_pressed()
			pressed_sfx.play()
