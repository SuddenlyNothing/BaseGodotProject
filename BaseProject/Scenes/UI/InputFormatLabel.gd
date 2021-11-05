extends Label

onready var unformatted_text = text

# Formats the text.
# Gets called by InputRemap and InputRemapButton when the keys
# for the buttons change or the keys are being loaded.
func update_keys() -> void:
	text = unformatted_text.format(Variables.input_format)
