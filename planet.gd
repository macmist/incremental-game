extends Sprite2D

class_name Planet

@export var walker_scene: PackedScene
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D

signal spawn(angle)

func _ready() -> void:
	spawn.connect(spawn_walker)

func spawn_walker(angle: float):
	var walker = walker_scene.instantiate()
	get_tree().current_scene.add_child(walker)
	
	var center = global_position
	var radius = collision_shape.shape.radius * collision_shape.scale.x 
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




#func _input(event):
	#if event is InputEventMouseButton:
		#var angle = 0  # TAU = 2*PI
		#spawn_walker(angle)
