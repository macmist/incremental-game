extends HBoxContainer

@export var resource_label_scene: PackedScene


func _ready():
	for i in CollectableResource.ResourceType.values():
		var label = resource_label_scene.instantiate()
		add_child(label)
		label.setup(i)
