extends MarginContainer

const DEFAULT_BRIGHTNESS := 1.0
const DEFAULT_CONTRAST := 1.0
const DEFAULT_SATURATION := 1.0

onready var brightness := $V/V/Brightness
onready var contrast := $V/V2/Contrast
onready var saturation := $V/V3/Saturation
onready var b_reset := $V/V/H/BReset
onready var c_reset := $V/V2/H/CReset
onready var s_reset := $V/V3/H/SReset
onready var reset := $V/Reset


# Updates Save for brightness
# Updates ScreenFilter shader params for brightness
func _on_Brightness_value_changed(value: float) -> void:
	Save.data.screen_brightness = value
	ScreenFilter.set_brightness(value)
	check_defaults()


# Updates Save for contrast
# Updates ScreenFilter shader params for contrast 
func _on_Contrast_value_changed(value: float) -> void:
	Save.data.screen_contrast = value
	ScreenFilter.set_contrast(value)
	check_defaults()


# Updates Save for saturation
# Updates ScreenFilter shader params for saturation
func _on_Saturation_value_changed(value: float) -> void:
	Save.data.screen_saturation = value
	ScreenFilter.set_saturation(value)
	check_defaults()


# Loads data from Save.
# Gets called from Save because this node is in the
# save group
func load_data() -> void:
	var screen_data = Save.data
	if not screen_data.loaded:
		screen_data.screen_brightness = DEFAULT_BRIGHTNESS
		screen_data.screen_contrast = DEFAULT_CONTRAST
		screen_data.screen_saturation = DEFAULT_SATURATION
	brightness.value = screen_data.screen_brightness
	contrast.value = screen_data.screen_contrast
	saturation.value = screen_data.screen_saturation
	
	check_defaults()


# Resets sliders.
# This also calls the signal methods (_on_Saturation_value_changed)
func _on_Reset_pressed() -> void:
	brightness.value = DEFAULT_BRIGHTNESS
	contrast.value = DEFAULT_CONTRAST
	saturation.value = DEFAULT_SATURATION
	check_defaults()


# Checks if brightness, contrast, and saturation values are at their default and
# sets reset to disabled if they are not at their defaults.
func check_defaults() -> void:
	reset.disabled = brightness.value == DEFAULT_BRIGHTNESS and\
			contrast.value == DEFAULT_CONTRAST and\
			saturation.value == DEFAULT_SATURATION
	set_reset_hidden()


# Sets brightness to default
func _on_BReset_pressed() -> void:
	brightness.value = DEFAULT_BRIGHTNESS
	check_defaults()


# Sets contrast to default
func _on_CReset_pressed() -> void:
	contrast.value = DEFAULT_CONTRAST
	check_defaults()


# Sets saturation to default
func _on_SReset_pressed() -> void:
	saturation.value = DEFAULT_SATURATION
	check_defaults()


# Sets reset hidden if value is at default
func set_reset_hidden() -> void:
	b_reset.visible = not brightness.value == DEFAULT_BRIGHTNESS
	c_reset.visible = not contrast.value == DEFAULT_CONTRAST
	s_reset.visible = not saturation.value == DEFAULT_SATURATION
