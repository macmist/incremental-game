extends Sprite2D

class_name CollectableResource

enum ResourceType {WOOD, STONE}

@export var total: int = 100
@export var remaining: int = 100
@export var resource_type: ResourceType = ResourceType.WOOD

@onready var area: Area2D = $Area2D


func _ready() -> void:
	area.input_pickable = true
	area.input_event.connect(_on_Area2D_input_event)


func collect(amount: int) -> int:
	var collected = min(amount, remaining)
	remaining -= collected
	show_floating_text(collected)
	if remaining <= 0:
		queue_free()
	return collected
	
func show_floating_text(amount: int):
	var text_scene = preload("res://Components/FloatingText.tscn")
	var text = text_scene.instantiate()
	var text_str = str("+" , amount, " ", GameManager.get_resource_name(resource_type))
	var color := Color.WHITE
	match resource_type:
		ResourceType.WOOD: color = Color.LIME_GREEN
		ResourceType.STONE: color = Color.GRAY
		_: color = Color.WHITE
	# Position it above the resource
	get_parent().add_child(text)
	text.global_position = global_position
	text.setup(text_str, color)
			
func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var collected = collect(GameManager.click_power)
		GameManager.add_resource(resource_type, collected)
