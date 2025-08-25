extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "Wood: %d" % GameManager.wood
	GameManager.wood_updated.connect(_on_wood_updated)


func _on_wood_updated(new_value: int):
	text = "Wood: %d" % new_value
