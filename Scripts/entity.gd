extends Sprite2D

@export var speed: float = 1.0   # radians per second
@export var collect_speed: int = 30

var angle: float = 0.0
var target_angle: float = 0.0
var radius: float = 100.0
var planet_position: Vector2 = Vector2.ZERO

var target: CollectableResource

var timer: Timer = Timer.new()

func _ready():
	timer.connect("timeout", collect)
	timer.wait_time = 3
	timer.one_shot = true
	add_child(timer)


func collect():
	if target:
		print("collecting")
		var collected = target.collect(collect_speed)
		if collected > 0:
			GameManager.add_resource(target.resource_type, collected)
		if not is_instance_valid(target) or target.remaining <= 0:
			target = null

func find_target():
	var trees = get_tree().get_nodes_in_group("Resources")
	if trees.size() == 0:
		return
	trees.sort_custom(func(a, b): return position.distance_to(a.position) < position.distance_to(b.position))
	var tree = trees[0]
	if tree:
		print("found tree at: ", tree.position)
		target = tree
		set_target(tree.position)


func set_planet(planet_position: Vector2, radius: float):
	self.planet_position = planet_position
	self.radius = radius + (self.texture.get_size().x * self.scale.x) / 2.0
	var offset = Vector2(cos(angle), sin(angle)) * self.radius
	position = planet_position + offset
	rotation = angle + PI/2
	print("position: ", position, " distance: ", radius)

func _process(delta):
	if target and not is_instance_valid(target):
		target = null
		timer.stop()
	if !target:
		find_target()
		timer.stop()
	else:
		# Move angle towards target
		if angle != target_angle:
			angle = move_toward_angle(angle, target_angle, speed * delta)

			# Update position
			var offset = Vector2(cos(angle), sin(angle)) * radius
			position = planet_position + offset
			rotation = angle + PI/2
			timer.stop()
		else:
			if timer.is_stopped():
				print("start timer")
				timer.start()


func set_target(world_pos: Vector2):
	# Convert any world position to a target angle relative to planet
	var dir = (world_pos - planet_position).normalized()
	target_angle = atan2(dir.y, dir.x)


func move_toward_angle(current: float, target: float, step: float) -> float:
	var diff = wrapf(target - current, -PI, PI)
	if abs(diff) <= step:
		return target
	return current + step * sign(diff)
