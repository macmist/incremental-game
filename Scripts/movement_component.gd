extends Node
class_name MovementComponent


@export_subgroup("Settings")
@export var speed: float = 500
@export var ground_acceleration_speed: float = 10.0
@export var ground_deceleration_speed: float = 25.0
@export var air_acceleration_speed: float = 10.0
@export var air_deceleration_speed: float = 3.0

func handle_horizontal_movement(body: CharacterBody2D, direction: float) -> void:
	#body.velocity.x = direction * speed
	var velocity_change_speed: float = 0.0
	if body.is_on_floor():
		velocity_change_speed = ground_acceleration_speed if direction != 0 else ground_deceleration_speed
	else:
		velocity_change_speed = air_acceleration_speed if direction != 0 else air_deceleration_speed
		
	body.velocity.x = move_toward(body.velocity.x, direction * speed, velocity_change_speed)
