class_name SaveData
extends Resource

# If resource has been loaded before
export(bool) var loaded: bool = false

# Screen settings
export(float) var screen_brightness: float
export(float) var screen_contrast: float
export(float) var screen_saturation: float

# Audio settings
export(Dictionary) var audio_buses: Dictionary

# Input settings
export(Dictionary) var actions: Dictionary
