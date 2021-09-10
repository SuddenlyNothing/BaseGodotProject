extends CanvasLayer

onready var tab_container := $M/TabContainer

var active = false setget set_active

func _input(event):
	if event is InputEventKey:
		if not event.is_pressed():
			if event.scancode == KEY_ESCAPE:
				self.active = not active


func _on_Button_pressed():
	tab_container.current_tab = 0


func _on_Audio_pressed():
	tab_container.current_tab = 1


func _on_Controls_pressed():
	tab_container.current_tab = 2


func _on_ScreenSettings_pressed():
	tab_container.current_tab = 3


func _on_Back_pressed():
	self.active = false


func set_active(val) -> void:
	active = val
	$M.visible = val
	get_tree().paused = val


func load_data() -> void:
	# inputs, volume, screen settings
	if "inputs" in Save.data:
		for action in Save.data["inputs"]:
			pass
	pass






