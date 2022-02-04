extends CanvasLayer

onready var color_rect := $ColorRect


# Sets shader param for brightness.
func set_brightness(val: float) -> void:
	color_rect.get_material().set_shader_param("brightness", val)


# Sets shader param for contrast
func set_contrast(val: float) -> void:
	color_rect.get_material().set_shader_param("contrast", val)


# Sets shader param for saturation
func set_saturation(val: float) -> void:
	color_rect.get_material().set_shader_param("saturation", val)
