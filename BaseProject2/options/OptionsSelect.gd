class_name OptionsSelect
extends Control

## To set up this script, include all respective onready nodes with scene unique
## node active. Audio, Controls, and ScreenSettings button need toggle mode to
## be true.

enum TAB {
	AUDIO,
	CONTROLS,
	SCREEN_SETTINGS,
}

export(NodePath) var start_focus_button_path
export(String, FILE, "*.tscn") var menu_scene

var current_setting = TAB.AUDIO setget set_current_setting
var previous_focus: Control
var prevent_menu := false

onready var audio: Button = $"%Audio"
onready var controls: Button = $"%Controls"
onready var screen_settings: Button = $"%ScreenSettings"
onready var settings: TabContainer = $"%Settings"
onready var back: Button = $"%Back"
onready var menu: Button = $"%Menu"
onready var start_focus_button: Control = get_node(start_focus_button_path)


func _ready() -> void:
	setup_signals()


# Sets up signals so I don't need to do them in editor
func setup_signals() -> void:
	audio.connect("toggled", self, "_on_button_toggled", ["AUDIO"])
	controls.connect("toggled", self, "_on_button_toggled", ["CONTROLS"])
	screen_settings.connect("toggled", self, "_on_button_toggled",
			["SCREEN_SETTINGS"])
	back.connect("pressed", self, "_on_Back_pressed")
	menu.connect("pressed", self, "_on_Menu_pressed")


# Sets active panel to the one associated with the given button
func _on_button_toggled(button_pressed: bool, button: String) -> void:
	if button_pressed:
		set_current_setting(TAB[button])


func set_focus_button_active(is_active: bool) -> void:
	if is_active:
		prevent_menu = false
		previous_focus = get_focus_owner()
		start_focus_button.grab_focus()
	else:
		start_focus_button = get_focus_owner()
		if previous_focus and is_instance_valid(previous_focus):
			previous_focus.grab_focus()


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


# Turns off pause menu
func _on_Back_pressed() -> void:
	OptionsMenu.set_active(false)


# Goes to main menu
func _on_Menu_pressed() -> void:
	if prevent_menu:
		return
	prevent_menu = true
	SceneHandler.goto_scene(menu_scene)
	OptionsMenu.set_active(false)
