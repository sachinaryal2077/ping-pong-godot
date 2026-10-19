extends Button

func on_custom_button_pressed() -> void:
	Sfx.play(Sfx.SoundName.MENU_BUTTON_CLICK, -10.0)
	
func _ready() -> void:
	pressed.connect(on_custom_button_pressed)
