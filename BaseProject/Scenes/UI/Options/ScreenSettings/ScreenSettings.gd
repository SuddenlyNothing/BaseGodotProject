extends Control

onready var brightness := $V/V/H/Brightness
onready var contrast := $V/V/H2/Contrast
onready var saturation := $V/V/H3/Saturation

func _on_Brightness_value_changed(value):
	Save.data.screen.brightness = value
	ScreenFilter.set_brightness(value)


func _on_Contrast_value_changed(value):
	Save.data.screen.contrast = value
	ScreenFilter.set_contrast(value)


func _on_Saturation_value_changed(value):
	Save.data.screen.saturation = value
	ScreenFilter.set_saturation(value)


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


func _on_Reset_pressed():
	brightness.value = 1
	contrast.value = 1
	saturation.value = 1
	
