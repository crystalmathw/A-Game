extends Area2D

@export var damage: float = 5

func _on_body_entered(body: Node2D) -> void:
	body.playerTakeDamage(damage)
