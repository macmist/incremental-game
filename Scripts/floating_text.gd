extends RichTextLabel

@export var lifetime: float = 1.0
@export var rise_distance: float = 40.0
@export var horizontal_jitter: float = 10.0
@export var drift_angle: float = 10.0 # max side drift in degrees

# Called right after spawning to set up the text
func setup(text: String, color: Color) -> void:
	self.text = text
	modulate = color

	# Apply horizontal jitter
	position.x += randf_range(-horizontal_jitter, horizontal_jitter)

	# Compute drift vector (small angle variation away from vertical)
	var angle = deg_to_rad(randf_range(-drift_angle, drift_angle))
	var offset = Vector2(sin(angle), -cos(angle)) * rise_distance

	# Tween setup
	var tween = create_tween()

	# Pop effect at the start
	scale = Vector2(0.8, 0.8)
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2.ONE, 0.1)

	# Rise & fade with drift
	tween.parallel().tween_property(self, "position", offset, lifetime).as_relative()
	tween.parallel().tween_property(self, "modulate:a", 0.0, lifetime)

	# Cleanup
	tween.tween_callback(Callable(self, "queue_free"))
