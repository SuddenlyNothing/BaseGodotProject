extends CanvasLayer

onready var canvas_modulate := $CanvasModulate

func set_brightness(val) -> void:
	canvas_modulate.get_material().set_shader_param("brightness", val)


func set_contrast(val) -> void:
	canvas_modulate.get_material().set_shader_param("contrast", val)


func set_saturation(val) -> void:
	canvas_modulate.get_material().set_shader_param("saturation", val)
