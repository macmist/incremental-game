extends Label

var resource_type: CollectableResource.ResourceType

# Called when the node enters the scene tree for the first time.
func setup(type: CollectableResource.ResourceType) -> void:
	resource_type = type
	update_text(GameManager.get_resource(type))
	GameManager.resource_updated.connect(_on_resource_changed)


func _on_resource_changed(changed_type: CollectableResource.ResourceType, new_value: int):
	if changed_type == resource_type:
		update_text(new_value)


func update_text(value: int):
	var res_name = GameManager.get_resource_name(resource_type)
	text = "%s: %d" % [res_name, value]
