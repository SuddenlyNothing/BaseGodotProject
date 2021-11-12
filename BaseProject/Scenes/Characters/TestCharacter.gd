extends KinematicBody2D

onready var test_character_states := $TestCharacterStates
onready var state_label := $StateLabel

var dir : Vector2 = Vector2()
var speed : float = 500.0


func _process(_delta : float):
	_set_state_label()
	_set_dir()

# Called by TestCharacterStates
func move() -> void:
	move_and_slide(dir.normalized() * speed)


func _set_dir() -> void:
	dir = Vector2()
	dir.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	dir.y = Input.get_action_strength("down") - Input.get_action_strength("up")


func _set_state_label() -> void:
	state_label.text = test_character_states.state
