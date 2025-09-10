extends Sprite2D

class_name WalkerEntity

enum State {IDLE, MOVING, COLLECTING, RETURNING, RESTING}
var state: State = State.IDLE

@export var speed: float = 1.0   # radians per second
@export var collect_speed: int = 30
@export var energy_max: int = 10
@export var rest_rate = 1

var angle: float = 0.0
var target_angle: float = 0.0
var home: Node2D
var home_angle: float = 0.0
var radius: float = 100.0
var planet_position: Vector2 = Vector2.ZERO
var energy: float = 0

var target: CollectableResource

var timer: Timer = Timer.new()

func _ready():
	timer.connect("timeout", collect)
	timer.wait_time = 3
	timer.one_shot = true
	add_child(timer)
	energy = energy_max


func collect():
	if target:
		print("collecting")
		var collected = target.collect(collect_speed)
		if collected > 0:
			GameManager.add_resource(target.resource_type, collected)
			energy -= 1
			if energy <= 0:
				energy = 0
				transition()
				print("IM TOO TIRED NOW")
		if not is_instance_valid(target) or target.remaining <= 0:
			target = null
			transition()
			
func collect_resource(delta):
	if timer.is_stopped():
		print("start timer")
		timer.start()

func find_target():
	var resources = get_tree().get_nodes_in_group("Resources")
	if resources.size() == 0:
		return
	resources.sort_custom(func(a, b): return position.distance_to(a.position) < position.distance_to(b.position))
	var resource = resources[0]
	if resource:
		print("found resource at: ", resource.position)
		target = resource
		set_target(resource.position)
		transition()


func remove_home():
	home = null
	home_angle = 0
	

func try_set_home():
	var house = find_nearest_house()
	if house and house.add_walker(self):
		print("Walker joined house")
	else:
		print("Couldn't find a suitable house")
		
func transition():
	match state:
		State.IDLE:
			state = State.MOVING
		State.MOVING:
			state = State.COLLECTING
		State.COLLECTING:
			if energy > 0:
				state = State.IDLE
			else:
				state = State.RETURNING
		State.RETURNING:
			state = State.RESTING
		State.RESTING:
			state = State.IDLE
		
func find_nearest_house() -> House:
	var houses = get_tree().get_nodes_in_group("Houses")
	var best_house: House = null
	var best_distance := INF
	
	for h in houses.filter(func(house): return house.placed):
		if h is House and h.has_space():
			var dist = global_position.distance_to(h.global_position)
			if dist < best_distance:
				best_distance = dist
				best_house = h
	
	return best_house

func set_home(home: Node2D):
	self.home = home
	var dir = (home.global_position - planet_position).normalized()
	home_angle = atan2(dir.y, dir.x)

func set_planet(planet_position: Vector2, radius: float):
	self.planet_position = planet_position
	self.radius = radius + (self.texture.get_size().x * self.scale.x) / 2.0
	var offset = Vector2(cos(angle), sin(angle)) * self.radius
	position = planet_position + offset
	rotation = angle + PI/2
	print("position: ", position, " distance: ", radius)
	
	
func _process(delta: float) -> void:
	if !home:
		try_set_home()
	match state:
		State.IDLE:
			find_target()
		State.MOVING:
			move_toward_target(delta)
		State.COLLECTING:
			collect_resource(delta)
		State.RETURNING:
			move_toward_home(delta)
		State.RESTING:
			rest(delta)


func rest(delta):
	print(rest_rate * delta)
	energy += rest_rate * delta
	if energy > energy_max:
		energy = energy_max
		transition()
		print("I am rested, back to work")
	else:
		print("Resting, energy at ", energy)
		
		
func move_toward_home(delta):
	if home != null && angle != home_angle:
		angle = move_toward_angle(angle, home_angle, speed * delta)

		# Update position
		var offset = Vector2(cos(angle), sin(angle)) * radius
		position = planet_position + offset
		rotation = angle + PI/2
		timer.stop()
	else:
		print("Now i rest")
		transition()

func move_toward_target(delta):
	if angle != target_angle:
		angle = move_toward_angle(angle, target_angle, speed * delta)

		# Update position
		var offset = Vector2(cos(angle), sin(angle)) * radius
		position = planet_position + offset
		rotation = angle + PI/2
		timer.stop()
	else:
		transition()


func set_target(world_pos: Vector2):
	# Convert any world position to a target angle relative to planet
	var dir = (world_pos - planet_position).normalized()
	target_angle = atan2(dir.y, dir.x)


func move_toward_angle(current: float, target: float, step: float) -> float:
	var diff = wrapf(target - current, -PI, PI)
	if abs(diff) <= step:
		return target
	return current + step * sign(diff)
