extends Node2D

export(String, FILE, "*.tscn") var next_scene



func _on_Button_pressed():
	Global.goto_scene(next_scene)
