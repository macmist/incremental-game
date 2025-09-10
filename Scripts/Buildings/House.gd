extends Placeable

class_name House

var capacity: int = 3
var occupants: Array[WalkerEntity] = []


func has_space() -> bool:
	return occupants.size() < capacity


func add_walker(walker: WalkerEntity) -> bool:
	if occupants.size() < capacity:
		occupants.append(walker)
		walker.set_home(self)  # give walker a reference back
		return true
	return false

func remove_walker(walker: WalkerEntity) -> void:
	if occupants.has(walker):
		occupants.erase(walker)
		walker.remove_home()
