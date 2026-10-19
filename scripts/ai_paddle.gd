extends CharacterBody2D

@export var speed: float = 350.0
@export var dead_zone: float = 10.0
@export var home_y: float = 320.0

@onready var ball: RigidBody2D = get_parent().get_node_or_null('Ball') as RigidBody2D


func _physics_process(_delta: float) -> void:
	if not is_instance_valid(ball):
		velocity = Vector2.ZERO
		move_and_slide()
		return
		
	var target_y: float = home_y
	
	if ball.linear_velocity.x > 0.0:
		target_y = ball.global_position.y
		
	var difference: float = target_y - global_position.y
	
	if absf(difference) <= dead_zone:
		velocity = Vector2.ZERO
	else:
		velocity = Vector2(0.0, signf(difference) * speed)
		
	move_and_slide()
		
