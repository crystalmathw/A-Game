extends Area2D

@export var damage: float = 5

@onready var damage_timer: Timer = $Timer

var target: Node2D = null

func _on_body_entered(body: Node2D) -> void:
	target = body
	target.playerTakeDamage(damage)
	damage_timer.start()  # Start the repeating damage

func _on_body_exited(body: Node2D) -> void:
	if body == target:
		target = null
		damage_timer.stop()

func _on_timer_timeout() -> void:
	if target and target.is_inside_tree() and target.getPlayerHealth() > 0:
		target.playerTakeDamage(damage)
