extends Node
class_name AnimationComponent

@export_subgroup("Nodes")
@export var anim_tree: AnimationTree

func handle_horiziontal_direction(h_direction: float) -> void:
	anim_tree["parameters/Idle/blend_position"] = Vector2(h_direction, 0)
	anim_tree["parameters/Attack/blend_position"] = h_direction
	
	
func handle_attack(is_attacking: bool, stopped_attacking: bool) -> void: 
	anim_tree["parameters/conditions/is_attacking"] = is_attacking
