extends Control

enum PlayerType {AI, HUMAN}

const GUIDE_SCENE := preload("res://scenes/guide.tscn")
const CUSTOMIZE_CONTROLS_SCENE := preload("res://scenes/customize_controls.tscn")
const COURT_CENTER: Vector2 = Vector2(640, 360)

@export var winning_score: int = 5

@onready var pause_menu = $PauseMenu
@onready var pause_menu_buttons: VBoxContainer = $PauseMenu/CenterContainer/MarginContainer/PanelContainer/PauseMenuButtons
@onready var resume_button: Button = $PauseMenu/CenterContainer/MarginContainer/PanelContainer/PauseMenuButtons/ResumeButton
@onready var guide_button: Button = $PauseMenu/CenterContainer/MarginContainer/PanelContainer/PauseMenuButtons/GuideButton
@onready var controls_button: Button = $PauseMenu/CenterContainer/MarginContainer/PanelContainer/PauseMenuButtons/ControlsButton
@onready var quit_to_menu_button: Button = $PauseMenu/CenterContainer/MarginContainer/PanelContainer/PauseMenuButtons/QuitToMenuButton
@onready var quit_to_desktop_button: Button = $PauseMenu/CenterContainer/MarginContainer/PanelContainer/PauseMenuButtons/QuitToDesktopButton

@onready var game_over_screen: CanvasLayer = $GameOverScreen
@onready var winner_name_label: Label = $GameOverScreen/GameOverMenu/CenterContainer/VBoxContainer/WinnerName
@onready var final_score_label: Label = $GameOverScreen/GameOverMenu/CenterContainer/VBoxContainer/FinalScore
@onready var restart_game_button: Button =$GameOverScreen/GameOverMenu/CenterContainer/VBoxContainer/RestartGameButton

@onready var ai_score_label:Label = $AIScoreLabel
@onready var player_score_label:Label = $PlayerScoreLabel

@onready var ai_paddle:CharacterBody2D = $Court/AIPaddle
@onready var player_paddle:CharacterBody2D = $Court/PlayerPaddle

@onready var ball: Ball = $Court/Ball

@onready var left_goal:Area2D = $Court/LeftGoal
@onready var right_goal:Area2D = $Court/RightGoal

var player_score: int = 0
var ai_score: int = 0
var point_in_progress: bool = false
var match_over: bool = false

var guide: Guide
var customize_controls: CustomizeControls

func _ready() -> void:
	pause_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	pause_menu.visible = false
	
	game_over_screen.process_mode =Node.PROCESS_MODE_ALWAYS
	game_over_screen.visible = false
	
	resume_button.pressed.connect(_on_resume_button_pressed)
	restart_game_button.pressed.connect(_on_restart_game_button_pressed)
	guide_button.pressed.connect(_on_guide_button_pressed)
	controls_button.pressed.connect(_on_controls_button_pressed)
	quit_to_menu_button.pressed.connect(_on_quit_to_menu_button_pressed)
	quit_to_desktop_button.pressed.connect(_on_quit_to_desktop_button_pressed)
	
	left_goal.body_entered.connect(_on_left_goal_body_entered)
	right_goal.body_entered.connect(_on_right_goal_body_entered)
	
	_update_score_labels()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_resume_game"):
		if guide != null:
			guide.queue_free()
			pause_menu_buttons.show()
		elif customize_controls != null:
			customize_controls.queue_free()
			pause_menu_buttons.show()
		else:
			pause_menu.visible = !pause_menu.visible
			get_tree().paused = pause_menu.visible

func _on_left_goal_body_entered(body: Node2D) -> void:
	if body != ball || point_in_progress || match_over:
		return
	
	point_in_progress = true
	call_deferred("_award_point", PlayerType.AI)

	
func _on_right_goal_body_entered(body: Node2D) -> void:
	if body != ball || point_in_progress || match_over:
		return
	
	point_in_progress = true
	call_deferred("_award_point", PlayerType.HUMAN)
	
func _award_point(scorer: PlayerType) -> void:
	if scorer == PlayerType.HUMAN:
		player_score += 1
	if scorer == PlayerType.AI:
		ai_score += 1
		
	_update_score_labels()
	ball.linear_velocity = Vector2.ZERO
	ball.angular_velocity = 0.0
	ball.global_position = COURT_CENTER
	
	if player_score >= winning_score:
		_end_match("PLAYER WINS!!!")
		return
		
	if ai_score >= winning_score:
		_end_match("AI WINS")
		return
		
	await get_tree().create_timer(0.8).timeout
	
	if match_over:
		return
	
	var horizontal_direction := -1.0 if scorer == PlayerType.HUMAN else 1.0
	var vertical_direction := randf_range(-0.45, 0.45)

	ball.launch(Vector2(horizontal_direction, vertical_direction))

	point_in_progress = false
		
func _end_match(message: String) -> void:
	match_over = true
	game_over_screen.visible = true
	
	ball.linear_velocity = Vector2.ZERO
	winner_name_label.text = message
	final_score_label.text = 'Player: %d AI: %d' % [player_score, ai_score]
	
			
func _update_score_labels() -> void:
	player_score_label.text = 'Player %d' % player_score
	ai_score_label.text = 'AI %d' % ai_score
	
func _on_resume_button_pressed() -> void:
	pause_menu.visible = false
	get_tree().paused = false
	
func _on_restart_game_button_pressed() -> void:
	player_score = 0
	ai_score = 0
	
	_update_score_labels()
	game_over_screen.hide()
	
	match_over = false
	point_in_progress = false
	
	ball.linear_velocity = Vector2.ZERO
	ball.angular_velocity = 0
	ball.global_position = COURT_CENTER
	
	player_paddle.position = Vector2(30.0, 360.0)
	ai_paddle.position = Vector2(1250.0, 360.0)
	
	await get_tree().create_timer(0.8).timeout
	
	if not match_over:
		ball.launch(Vector2(1.0, randf_range(-0.45, 0.45)))
		
	point_in_progress = false
		
	
func _on_guide_back_button_pressed() -> void:
	guide.queue_free()
	pause_menu_buttons.show()
	
func _on_guide_button_pressed() -> void:
	guide = GUIDE_SCENE.instantiate()
	guide.on_back_button_pressed.connect(_on_guide_back_button_pressed)
	pause_menu.add_child(guide)
	pause_menu_buttons.hide()
	
func _on_customize_controls_back_button_pressed() -> void:
	customize_controls.queue_free()
	pause_menu_buttons.show()
	
func _on_controls_button_pressed() -> void:
	customize_controls = CUSTOMIZE_CONTROLS_SCENE.instantiate()
	customize_controls.on_back_button_pressed.connect(_on_customize_controls_back_button_pressed)
	pause_menu.add_child(customize_controls)
	pause_menu_buttons.hide()
	
func _on_quit_to_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func _on_quit_to_desktop_button_pressed() -> void:
	get_tree().quit()
