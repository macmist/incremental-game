extends Sprite2D

@export var speed: float = 1.0   # radians per second

var angle: float = 0.0
var target_angle: float = 0.0
var radius: float = 100.0
var planet_position: Vector2 = Vector2.ZERO



func set_planet(planet_position: Vector2, radius: float):
	self.planet_position = planet_position
	self.radius = radius + (self.texture.get_size().x * self.scale.x) / 2.0
	print("position: ", position, " distance: ", radius)

func _process(delta):
	# Move angle towards target
	if angle != target_angle:
		angle = move_toward_angle(angle, target_angle, speed * delta)

	# Update position
	var offset = Vector2(cos(angle), sin(angle)) * radius
	position = planet_position + offset
	rotation = angle + PI/2


func set_target(world_pos: Vector2):
	# Convert any world position to a target angle relative to planet
	var dir = (world_pos - planet_position).normalized()
	target_angle = atan2(dir.y, dir.x)


func move_toward_angle(current: float, target: float, step: float) -> float:
	var diff = wrapf(target - current, -PI, PI)
	if abs(diff) <= step:
		return target
	return current + step * sign(diff)


func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		set_target(event.position)
