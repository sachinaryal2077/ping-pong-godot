extends Node

signal input_mapping_changed(action: StringName)

const SAVE_PATH = "user://input_settings.cfg" # Specifies where to save the user keybindings
const KEYBINDINGS_SECTION_NAME = "keybindings" # Section name for storing keybindings
const ACTIONS := [&"paddle_up", &"paddle_down"] # Registered actions

var _default_keybindings: Dictionary = {}

func _ready() -> void:
	for action in ACTIONS:
		_default_keybindings[action] = get_keycode(action)
	load_keybindings()
	
func get_keycode(action: StringName) -> Key:
	for event in InputMap.action_get_events(action):
		if event is InputEventKey:
			if event.physical_keycode != KEY_NONE:
				return event.physical_keycode
			return event.keycode
	return KEY_NONE
	
func load_keybindings() -> void:
	var config := ConfigFile.new()
	
	if config.load(SAVE_PATH) != OK:
		return
	
	for action in ACTIONS:
		if config.has_section(KEYBINDINGS_SECTION_NAME):
			_set_keycode(action, config.get_value(KEYBINDINGS_SECTION_NAME,action) as Key)
			input_mapping_changed.emit(action)
			
func save_bindings() -> void:
	var config := ConfigFile.new()
	for action in ACTIONS:
		config.set_value(KEYBINDINGS_SECTION_NAME,action, int(get_keycode(action)))
	var error := config.save(SAVE_PATH)
	if error != OK:
		push_warning('Could not save input settings (error %d)' % error)
		
func reset_to_defaults() -> void:
	for action in ACTIONS:
		_set_keycode(action, _default_keybindings[action])
		input_mapping_changed.emit(action)
	save_bindings()
	
func rebind(action: StringName, new_keycode: Key) -> void:
	var old_keycode := get_keycode(action)

	for other in ACTIONS:
		if other != action and get_keycode(other) == new_keycode:
			_set_keycode(other, old_keycode)   # give the other action our old key
			input_mapping_changed.emit(other)

	_set_keycode(action, new_keycode)
	input_mapping_changed.emit(action)
	save_bindings()

func get_key_label(action: StringName) -> String:
	var code := get_keycode(action)
	if code == KEY_NONE:
		return "Unbound"
	var layout_key := DisplayServer.keyboard_get_keycode_from_physical(code)
	return OS.get_keycode_string(layout_key)

func _set_keycode(action:StringName, key: Key) -> void:
	InputMap.action_erase_events(action)
	
	if key == KEY_NONE:
		return
	var event := InputEventKey.new()
	event.physical_keycode = key
	InputMap.action_add_event(action, event)
