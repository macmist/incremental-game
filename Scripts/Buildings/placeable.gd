extends Sprite2D

class_name Placeable

var angle: float = 0.0
var radius: float = 100.0
var planet_position: Vector2 = Vector2.ZERO
var placed: bool = false

func _ready() -> void:
	modulate.a = 0.5

func set_planet(planet_position: Vector2, radius: float):
	self.planet_position = planet_position
	self.radius = radius + (self.texture.get_size().x * self.scale.x) / 2.0
	var offset = Vector2(cos(angle), sin(angle)) * self.radius
	position = planet_position + offset
	rotation = angle + PI/2
	
func _process(delta: float) -> void:
	if placed:
		return
	var world_pos = get_global_mouse_position()
	var dir = (world_pos - planet_position).normalized()
	angle = atan2(dir.y, dir.x)
	angle = round(angle / deg_to_rad(15)) * deg_to_rad(15)
	var offset = Vector2(cos(angle), sin(angle)) * radius
	position = planet_position + offset
	rotation = angle + PI/2

func _unhandled_input(event: InputEvent) -> void:
	if placed:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			placed = true
			modulate.a = 1.0
