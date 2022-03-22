extends Label

onready var unformatted_text = text


func _ready() -> void:
	update_keys()


# Updates label to match controls
func update_keys() -> void:
	text = unformatted_text.format(Variables.input_format)
