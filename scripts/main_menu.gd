extends Control

const GUIDE_SCENE := preload("res://scenes/guide.tscn")
const CUSTOMIZE_CONTROLS_SCENE := preload("res://scenes/customize_controls.tscn")

@onready var menu_buttons_container: VBoxContainer = $MenuCenter/MenuLayout/MenuButtons
@onready var start_game_button: Button = $MenuCenter/MenuLayout/MenuButtons/StartGameButton
@onready var guide_button: Button = $MenuCenter/MenuLayout/MenuButtons/GuideButton
@onready var controls_button: Button = $MenuCenter/MenuLayout/MenuButtons/ControlsButton
@onready var exit_game_button: Button = $MenuCenter/MenuLayout/MenuButtons/ExitGameButton

var guide: Guide
var customize_controls: CustomizeControls
	
func on_start_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	
func _on_guide_menu_back_button_pressed() -> void:
	guide.queue_free()
	menu_buttons_container.show()
	
func on_guide_button_pressed() -> void:
	guide = GUIDE_SCENE.instantiate() as Guide
	guide.on_back_button_pressed.connect(_on_guide_menu_back_button_pressed)
	add_child(guide)
	menu_buttons_container.hide()
	
func _on_customize_controls_back_button_pressed() -> void:
	customize_controls.queue_free()
	menu_buttons_container.show()
	
func on_controls_button_pressed() -> void:
	customize_controls = CUSTOMIZE_CONTROLS_SCENE.instantiate()
	customize_controls.on_back_button_pressed.connect(_on_customize_controls_back_button_pressed)
	add_child(customize_controls)
	menu_buttons_container.hide()
	
func on_exit_game_button_pressed() -> void:
	get_tree().quit()
	
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	start_game_button.pressed.connect(on_start_game_button_pressed)
	guide_button.pressed.connect(on_guide_button_pressed)
	controls_button.pressed.connect(on_controls_button_pressed)
	exit_game_button.pressed.connect(on_exit_game_button_pressed)
