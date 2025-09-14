extends Node
class_name MovementComponent


@export_subgroup("Settings")
@export var speed: float = 100

func handle_horizontal_movement(body: CharacterBody2D, direction: float) -> void:
	body.velocity.x = direction * speed
	print(direction * speed)
