extends Node2D

@export var planet: Planet
@export var tree: PackedScene
@export var rock: PackedScene
@export var house: PackedScene


func _ready() -> void:
	for i in range(GameManager.initial_resources_spawn):
		planet.spawn_object.emit(tree)
		planet.spawn_object.emit(rock)


func _on_button_pressed() -> void:
	if GameManager.spend_resource(CollectableResource.ResourceType.WOOD, GameManager.spawn_cost):
		planet.spawn.emit(20)
		GameManager.update_spawn_cost()
	


func _on_button_2_pressed() -> void:
	planet.spawn_object.emit(tree)


func _on_button_3_pressed() -> void:
	planet.spawn_object.emit(rock)


func _on_button_4_pressed() -> void:
	planet.spawn_object.emit(house)
