extends Node

enum SoundName  { MENU_BUTTON_CLICK  }
const SOUNDS := {
	SoundName.MENU_BUTTON_CLICK: preload("res://assets/sound_effects/menu_click.mp3")
}

func play(sound_name: SoundName, volume_db: float = 0.0) -> void:
	if not SOUNDS.has(sound_name):
		push_warning("Sfx: unknown sound '%s'" % sound_name)
		return
	var audio := AudioStreamPlayer.new()
	audio.stream = SOUNDS[sound_name]
	audio.volume_db = volume_db
	add_child(audio)
	audio.finished.connect(audio.queue_free)
	audio.play()
