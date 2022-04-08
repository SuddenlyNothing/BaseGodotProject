extends Control

onready var transition := $CanvasLayer/ScreenWipe

var loader : ResourceInteractiveLoader
var wait_frames : int
var time_max : int = 10 # msec
var current_scene
var current_scene_res : PackedScene


# Sets the current scene.
func _ready() -> void:
	var root := get_tree().get_root()
	current_scene = root.get_child( root.get_child_count() -1 )
	wait_frames = 1


# Loads resource if a loading is needed and updates progress while doing so
func _process(delta: float) -> void:
	if loader == null:
		# no need to process anymore
		set_process(false)
		return

	# Wait for frames to let the "loading" animation show up.
	if wait_frames > 0:
		wait_frames -= 1
		return

	var t = 0
	# Use "time_max" to control for how long we block this thread.
	while t < time_max:
		t += delta
		# Poll your loader.
		var err := loader.poll()

		if err == ERR_FILE_EOF: # Finished loading.
			var resource := loader.get_resource()
			loader = null
			set_new_scene(resource)
			break
		elif err == OK:
			update_progress()
		else: # Error during loading.
			printerr("Error during loading")
			loader = null
			break


# Reloads the current scene
func restart_scene() -> void:
	transition.fade_out()
	yield(transition, "faded_out")
	current_scene.queue_free()
	call_deferred("set_new_scene", current_scene_res)


# Fades out, frees current scene then starts loading the new scene.
# Goes to the scene at the given path
func goto_scene(path: String) -> void:
	loader = ResourceLoader.load_interactive(path)
	assert(loader != null)
	
	transition.fade_out()
	yield(transition, "faded_out")
	
	current_scene.queue_free() # Get rid of the old scene.
	set_process(true)


# Update progress here
func update_progress() -> void:
	var progress = float(loader.get_stage()) / loader.get_stage_count()
	print(progress)


# Sets the new scene to the given scene_resource
func set_new_scene(scene_resource: PackedScene) -> void:
	current_scene_res = scene_resource
	current_scene = scene_resource.instance()
	current_scene.connect("ready", self, "new_scene_ready")
	get_node("/root").add_child(current_scene)


# Fades into the new scene
func new_scene_ready() -> void:
	transition.fade_in()
