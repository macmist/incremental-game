extends Node2D

@export var planet: Planet


func _on_button_pressed() -> void:
	planet.spawn.emit(20)
