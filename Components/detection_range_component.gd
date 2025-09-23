extends Area2D
class_name DetectionRangeComponent

signal found_target(player: Player)
signal target_escaped(player: Player)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		found_target.emit(body)


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		target_escaped.emit(body)
