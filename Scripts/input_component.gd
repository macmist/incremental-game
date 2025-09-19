extends Node
class_name InputComponent

var input_horizontal: float = 0.0


func _process(delta: float) -> void:
	input_horizontal = Input.get_axis("move_left","move_right")
	
func get_jump_input() -> bool:
	return Input.is_action_just_pressed("jump")
	
func get_jump_input_released() -> bool:
	return Input.is_action_just_released("jump")
	
func get_attack_input() -> bool:
	return Input.is_action_just_pressed("attack")
	
func get_attack_input_released() -> bool:
	return Input.is_action_just_released("attack")
