extends Node

class_name CollectableResource

@export var total: int = 100
@export var remaining: int = 100


func collect(amount: int) -> int:
	var collected = min(amount, remaining)
	remaining -= collected
	print("removing:", collected, " remaining: ", remaining)
	
	if remaining <= 0:
		print("empty, deleting")
		queue_free()
	return collected
	
