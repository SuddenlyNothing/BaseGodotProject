extends Control

onready var transition := $CanvasLayer/ScreenWipe

var current_scene
var previous_scene : String


# Sets the current scene.
func _ready() -> void:
	var root = get_tree().get_root()
	current_scene = root.get_child( root.get_child_count() -1 )


# Goes to scene with a fade out fade in transition.
# Pauses the game during transition.
func goto_scene(path : String) -> void:
	get_tree().paused = true
	previous_scene = current_scene.filename
	transition.fade_out()
	yield(transition, "faded_out")
	call_deferred("_deferred_goto_scene", path)


# Called by goto_scene to handle freeing the current scene.
func _deferred_goto_scene(path : String) -> void:
	# Load new scene
	var s = ResourceLoader.load(path)

	# Instance the new scene
	current_scene = s.instance()

	get_tree().change_scene_to(s)
	
	transition.fade_in()
	get_tree().paused = false


# Exits and returns to current scene.
func restart_scene() -> void:
	goto_scene(current_scene.filename)
