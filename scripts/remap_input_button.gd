extends Button

@export var action: StringName = &"paddle_up"
@export var display_text:String = ""

var is_listening: bool = false

func _ready() -> void:
	toggle_mode = true
	toggled.connect(_on_toggled)
	InputSettings.input_mapping_changed.connect(_on_input_mapping_changed)
	_refresh_text()
	
func _on_toggled(is_button_pressed: bool) -> void:
	is_listening = is_button_pressed
	if is_listening:
		text = "Press a key... (Esc to cancel)"
	else:
		_refresh_text()
		
func _input(event: InputEvent) -> void:
	if not is_listening:
		return
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		get_viewport().set_input_as_handled()
		if (event as InputEventKey).physical_keycode != KEY_ESCAPE:
			InputSettings.rebind(action, (event as InputEventKey).physical_keycode)
		_stop_listening()

func _stop_listening() -> void:
		is_listening = false
		button_pressed = false
		release_focus()
		_refresh_text()
		
func _on_input_mapping_changed(changed_action: StringName) -> void:
	if changed_action == action:
		_refresh_text()
	
func _refresh_text() -> void:
	if not is_listening:
		var action_key_label := InputSettings.get_key_label(action)
		text = "Press {key} to {display_text}".format({"key": action_key_label, "display_text":display_text.to_lower()})
