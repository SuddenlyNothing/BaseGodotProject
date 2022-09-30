extends AudioStreamPlayer2D

export(Array, AudioStream) var audio_streams := []


func play(from_position: float = 0.0) -> void:
	if stream is AudioStreamRandomPitch:
		stream.audio_stream = audio_streams[
			round(randf() * (len(audio_streams) - 1))
		]
	else:
		stream = audio_streams[round(randf() * (len(audio_streams) - 1))]
	.play(from_position)
