extends AnimatedButton

export(String, FILE, "*.tscn") var next_scene


func _pressed() -> void:
	SceneHandler.goto_scene(next_scene)
