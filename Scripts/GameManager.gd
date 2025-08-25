extends Node


var wood: int = 0

signal wood_updated(new_value: int)


func add_wood(amount: int):
	wood += amount
	wood_updated.emit(wood)
	
func spend_wood(amount: int) -> bool:
	if wood >= amount:
		wood -= amount
		wood_updated.emit(wood)
		return true
	else:
		return false
