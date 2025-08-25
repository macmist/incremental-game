extends Node2D

@export var planet: Planet
@export var tree: PackedScene


func _on_button_pressed() -> void:
	planet.spawn.emit(20)
	
	


func _on_button_2_pressed() -> void:
	planet.spawn_object.emit(tree)
