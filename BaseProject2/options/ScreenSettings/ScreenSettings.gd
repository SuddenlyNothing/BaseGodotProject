extends VBoxContainer

const DEFAULT_BRIGHTNESS := 1.0
const DEFAULT_CONTRAST := 1.0
const DEFAULT_SATURATION := 1.0

onready var brightness := $V/Brightness
onready var contrast := $V2/Contrast
onready var saturation := $V3/Saturation
onready var reset := $Reset


# Updates Save for brightness
# Updates ScreenFilter shader params for brightness
func _on_Brightness_value_changed(value: float) -> void:
	Save.data.screen.brightness = value
	ScreenFilter.set_brightness(value)
	check_defaults()


# Updates Save for contrast
# Updates ScreenFilter shader params for contrast 
func _on_Contrast_value_changed(value: float) -> void:
	Save.data.screen.contrast = value
	ScreenFilter.set_contrast(value)
	check_defaults()


# Updates Save for saturation
# Updates ScreenFilter shader params for saturation
func _on_Saturation_value_changed(value: float) -> void:
	Save.data.screen.saturation = value
	ScreenFilter.set_saturation(value)
	check_defaults()


# Loads data from Save.
# Gets called from Save because this node is in the
# save group
func load_data() -> void:
	if "screen" in Save.data:
		var screen_data = Save.data.screen
		brightness.value = screen_data.brightness
		contrast.value = screen_data.contrast
		saturation.value = screen_data.saturation
	else:
		Save.data["screen"] = {
			"brightness":1,
			"contrast":1,
			"saturation":1
		}
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
	if brightness.value == DEFAULT_BRIGHTNESS &&\
			contrast.value == DEFAULT_CONTRAST &&\
			saturation.value == DEFAULT_SATURATION:
		reset.disabled = true
	else:
		reset.disabled = false
