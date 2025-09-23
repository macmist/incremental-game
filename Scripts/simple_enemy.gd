extends CharacterBody2D

@export_subgroup("Nodes")
@export var detectionRange: DetectionRangeComponent
@export var gravityComponent: GravityComponent

@export_subgroup("Settings")
@export var attack_range = 100
@export var speed = 100

var target: Player

enum State {IDLE, CHASING, ATTACKING}
var state: State = State.IDLE

func _ready() -> void:
	detectionRange.found_target.connect(set_target)
	detectionRange.target_escaped.connect(remove_target)


func set_target(new_target: Player) -> void:
	target = new_target
	transition()
	print("Found my target")
	
func remove_target(escaped_target: Player) -> void:
	if escaped_target == target:
		escaped_target = null
		transition()
		print("My target escaped")
		
func transition():
	match state:
		State.IDLE:
			state = State.CHASING
		State.CHASING:
			if target and target.position.distance_to(self.position) <= attack_range:
				state = State.ATTACKING
			else:
				state = State.IDLE
		State.ATTACKING:
			state = State.CHASING


func _physics_process(delta: float) -> void:
	if gravityComponent:
		gravityComponent.handle_gravity(self, delta)
		
	match state:
		State.IDLE:
			idle(delta)
		State.CHASING:
			chase(delta)
		State.ATTACKING:
			attack(delta)
	move_and_slide()


func chase(delta):
	position += position.direction_to(target.position) * speed * delta
	print(target.position.distance_to(self.position))
	if target and target.position.distance_to(self.position) <= attack_range:
		transition()
	
func idle(delta):
	pass
	
func attack(delta):
	print("Attacking")
	if target and target.position.distance_to(self.position) > attack_range:
		transition()
