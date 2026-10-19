extends RigidBody2D

class_name Ball

@export var launch_speed: float = 420.0

func _ready() -> void:
	var direction := Vector2(0.65, 0.75)
	launch(direction)

func launch(direction: Vector2) -> void:
	linear_velocity = direction.normalized() * launch_speed
