extends CanvasLayer
# Shader can be found in the material section of the ColorRect

onready var color_rect := $ColorRect

# Sets shader param for brightness.
func set_brightness(val) -> void:
	color_rect.get_material().set_shader_param("brightness", val)

# Sets shader param for contrast
func set_contrast(val) -> void:
	color_rect.get_material().set_shader_param("contrast", val)

# Sets shader param for saturation
func set_saturation(val) -> void:
	color_rect.get_material().set_shader_param("saturation", val)
