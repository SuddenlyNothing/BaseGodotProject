extends HSlider

onready var change_sfx := $ChangeSFX


func _on_HSliderSFX_value_changed(_value: float) -> void:
	change_sfx.play()
