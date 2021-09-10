extends Sprite

var speed := 500

func _physics_process(delta : float) -> void:
	var dir = Vector2()
	dir.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	dir.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	position += dir.normalized() * speed * delta
