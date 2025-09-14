extends Sprite2D

class_name Planet

@export var walker_scene: PackedScene
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D

signal spawn(angle)
signal spawn_object(packed_scene)

func _ready() -> void:
	spawn.connect(spawn_walker)
	spawn_object.connect(spawn_static_object)

func spawn_walker(angle: float):
	var walker = walker_scene.instantiate()
	get_tree().current_scene.add_child(walker)
	
	var center = global_position
	var radius = collision_shape.shape.radius * scale.x 
	#var radius = (self.texture.get_size().x * self.scale.x) / 2.0
	print("radius:", radius)
	
	var pos = center + Vector2(cos(angle), sin(angle)) * radius
	print("destination: ", position)
	walker.global_position = pos
	walker.rotation = angle + PI/2  
	
	# If your walker has a script with planet info
	if walker.has_method("set_planet"):
		print(center, radius)
		walker.set_planet(center, radius)


func get_radius() -> float:
	var circle = collision_shape.shape as CircleShape2D
	return circle.radius * scale.x


func spawn_static_object(scene: PackedScene):
	var obj = scene.instantiate()
	get_tree().current_scene.add_child(obj)

	var center = global_position
	var radius = get_radius()

	# Pick a random angle
	var angle = randf() * TAU
	var pos = center + Vector2(cos(angle), sin(angle)) * radius

	# Optional: push outward a bit if the sprite should sit outside the circle
	var sprite = obj
	if sprite:
		var half_height = (sprite.texture.get_size().y * sprite.scale.y) / 2
		pos = center + Vector2(cos(angle), sin(angle)) * radius + Vector2(cos(angle), sin(angle)) * half_height
	else:
		print("Nope")

	obj.global_position = pos
	obj.rotation = angle + PI/2   # makes it “stand upright” on the surface
	if obj.has_method("set_planet"):
		print(center, radius)
		obj.set_planet(center, radius)

#func _input(event):
	#if event is InputEventMouseButton:
		#var angle = 0  # TAU = 2*PI
		#spawn_walker(angle)
