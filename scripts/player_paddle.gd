extends CharacterBody2D

@export var speed: float = 500.0

func _physics_process(_delta: float) -> void:
	var direction := Input.get_axis('paddle_up','paddle_down')
	velocity = Vector2(0.0, direction * speed)
	move_and_slide()
