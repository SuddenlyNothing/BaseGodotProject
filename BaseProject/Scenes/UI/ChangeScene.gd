extends Button

export(String, FILE, "*.tscn") var next_scene

# changes scene to next_scene
func _on_ChangeScene_pressed():
	Global.goto_scene(next_scene)
