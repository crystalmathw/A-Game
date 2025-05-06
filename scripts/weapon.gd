extends Node2D  # or Area2D if you want collision

var velocity: Vector2

func _physics_process(delta):
	position += velocity * delta
