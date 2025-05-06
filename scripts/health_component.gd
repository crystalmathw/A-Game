extends Node2D
class_name HealthComponent

@export var MAX_Health: float = 100

signal take_damage
signal is_dead

var health: float

func _ready() -> void:
	health = MAX_Health

func getHealth() -> float:
	return health

func damage(attack: Attack):
	health -= attack.attack_damage
	take_damage.emit()
	
	if health <=0:
		is_dead.emit()

func addHealth(attack: Attack) -> void:
	if health >= MAX_Health:
		health -= attack.heal
	else:
		pass

func reset() -> void:
	health = MAX_Health
