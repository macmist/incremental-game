extends Node

class_name CollectableResource

enum ResourceType {WOOD, STONE}

@export var total: int = 100
@export var remaining: int = 100
@export var resource_type: ResourceType = ResourceType.WOOD


func collect(amount: int) -> int:
	var collected = min(amount, remaining)
	remaining -= collected
	print("removing:", collected, " remaining: ", remaining)
	
	if remaining <= 0:
		print("empty, deleting")
		queue_free()
	return collected
	
