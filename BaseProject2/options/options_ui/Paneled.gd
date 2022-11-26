extends OptionsSelect

var is_mouse_inside := false

onready var settings_manager := $M/V
onready var pressed_sfx := $PressedSFX


func _on_ColorRect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1:
			yield(get_tree(), "idle_frame")
			if not event.is_pressed() and is_mouse_inside:
				_on_Back_pressed()
				pressed_sfx.play()


func _on_ColorRect_mouse_entered() -> void:
	is_mouse_inside = true


func _on_ColorRect_mouse_exited() -> void:
	is_mouse_inside = false
