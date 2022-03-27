extends Node

var music : Dictionary = {}
var num_lowers : int = 0
var current : String = ""


func _ready() -> void:
	for i in get_children():
		music[i.name.to_lower()] = i


func play(song: String) -> void:
	song = song.to_lower()
	if song == current:
		return
	stop_all()
	music[song].play()
	current = song


func stop_all() -> void:
	for child in get_children():
		child.stop()
	current = ""


func lower_volume() -> void:
	if num_lowers == 0:
		for child in get_children():
			child.volume_db -= 5
	num_lowers += 1


func increase_volume() -> void:
	if num_lowers == 1:
		for child in get_children():
			child.volume_db += 5
	num_lowers -= 1
