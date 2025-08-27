extends Node2D

@export var planet: Planet
@export var tree: PackedScene


func _on_button_pressed() -> void:
	if GameManager.spend_resource(CollectableResource.ResourceType.WOOD, GameManager.spawn_cost):
		planet.spawn.emit(20)
		GameManager.update_spawn_cost()
	
	


func _on_button_2_pressed() -> void:
	planet.spawn_object.emit(tree)
