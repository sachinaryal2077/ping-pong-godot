class_name CustomizeControls
extends Control

signal on_back_button_pressed
@onready var return_to_menu_button: Button = $CustomizeControlsCentered/CustomizeControlsVBox/ReturnToMenuButton

func _on_return_to_menu_button_pressed() -> void:
	on_back_button_pressed.emit()

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	return_to_menu_button.pressed.connect(_on_return_to_menu_button_pressed)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_resume_game"):
		_on_return_to_menu_button_pressed()
