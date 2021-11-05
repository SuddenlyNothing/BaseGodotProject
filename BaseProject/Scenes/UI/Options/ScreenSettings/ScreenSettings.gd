extends Control

onready var brightness := $V/V/H/Brightness
onready var contrast := $V/V/H2/Contrast
onready var saturation := $V/V/H3/Saturation

# Updates Save for brightness
# Updates ScreenFilter shader params for brightness
func _on_Brightness_value_changed(value):
	Save.data.screen.brightness = value
	ScreenFilter.set_brightness(value)

# Updates Save for contrast
# Updates ScreenFilter shader params for contrast 
func _on_Contrast_value_changed(value):
	Save.data.screen.contrast = value
	ScreenFilter.set_contrast(value)

# Updates Save for saturation
# Updates ScreenFilter shader params for saturation
func _on_Saturation_value_changed(value):
	Save.data.screen.saturation = value
	ScreenFilter.set_saturation(value)

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

# Resets sliders.
# This also calls the signal methods (_on_Saturation_value_changed)
func _on_Reset_pressed():
	brightness.value = 1
	contrast.value = 1
	saturation.value = 1
	
