extends CanvasLayer

@onready var restart_game_button: Button = $GameOverMenu/CenterContainer/VBoxContainer/RestartGameButton
@onready var quit_to_menu_button: Button = $GameOverMenu/CenterContainer/VBoxContainer/QuitToMenuButton
@onready var quit_game_button:Button = $GameOverMenu/CenterContainer/VBoxContainer/QuitGameButton

func _on_quit_to_menu_button_pressed() -> void:
	get_tree().change_scene_to_file('res://scenes/main_menu.tscn')
	
func _on_quit_game_button_pressed() -> void:
	get_tree().quit()

func _ready() -> void:
	hide()
	quit_to_menu_button.pressed.connect(_on_quit_to_menu_button_pressed)
	quit_game_button.pressed.connect(_on_quit_game_button_pressed)
