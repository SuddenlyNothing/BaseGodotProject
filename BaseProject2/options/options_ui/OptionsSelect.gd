extends Control

enum TAB {
	AUDIO,
	CONTROLS,
	SCREEN_SETTINGS,
}

var current_setting = TAB.AUDIO setget set_current_setting

onready var audio : Button = $V/Audio
onready var controls : Button = $V/Controls
onready var screen_settings : Button = $V/ScreenSettings
onready var settings : TabContainer = $V2/Settings


func _on_button_toggled(button_pressed: bool, button: String) -> void:
	if button_pressed:
		set_current_setting(TAB[button])


# Sets the active tab
func set_current_setting(val: int) -> void:
	current_setting = val
	settings.current_tab = val
	for i in TAB:
		match TAB[i]:
			TAB.AUDIO:
				if TAB[i] == val:
					audio.disabled = true
					continue
				audio.pressed = false
				audio.disabled = false
			TAB.CONTROLS:
				if TAB[i] == val:
					controls.disabled = true
					continue
				controls.pressed = false
				controls.disabled = false
			TAB.SCREEN_SETTINGS:
				if TAB[i] == val:
					screen_settings.disabled = true
					continue
				screen_settings.pressed = false
				screen_settings.disabled = false


func _on_Back_pressed() -> void:
	OptionsMenu.set_active(false)
