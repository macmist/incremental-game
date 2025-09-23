extends Node
class_name AnimationComponent

@export_subgroup("Nodes")
@export var anim_tree: AnimationTree

var last_direction: float = -1

func handle_horiziontal_direction(h_direction: float) -> void:
	if h_direction != 0: 
		last_direction = h_direction
	anim_tree["parameters/Idle/blend_position"] = Vector2(last_direction, 0)
	anim_tree["parameters/Attack/blend_position"] = last_direction
	
	
	
func handle_attack(is_attacking: bool, stopped_attacking: bool) -> void: 
	anim_tree["parameters/conditions/is_attacking"] = is_attacking
