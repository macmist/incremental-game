extends Node


var spawn_cost: int = 0
var click_power: int = 1
var initial_resources_spawn: int = 3

signal resource_updated(resource_type: CollectableResource.ResourceType, new_value: int)

var resources: Dictionary = {}

func _init() -> void:
	# Initialize resources dictionary from enum
	for type in CollectableResource.ResourceType.values():
		resources[type] = 0

func add_resource(resource_type: CollectableResource.ResourceType, amount: int):
	if not resources.has(resource_type):
		resources[resource_type] = 0
	resources[resource_type] += amount
	resource_updated.emit(resource_type, resources[resource_type])
	
func spend_resource(resource_type: CollectableResource.ResourceType, amount: int) -> bool:
	if resources.get(resource_type, 0) >= amount:
		resources[resource_type] -= amount
		resource_updated.emit(resource_type, resources[resource_type])
		return true
	else:
		return false

func get_resource(resource_type: CollectableResource.ResourceType) -> int:
	return resources.get(resource_type, 0)
	
func get_resource_name(type: CollectableResource.ResourceType) -> String:
	return CollectableResource.ResourceType.keys()[type].capitalize()

func update_spawn_cost():
	spawn_cost += 100
