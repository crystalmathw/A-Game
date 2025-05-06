extends Area2D


@export var attack_damage: float
@export var knockback_force: float
@export var stun_time: float
@export var heal: float




func _on_hitbox_area_entered(area: Area2D) -> void:
	print(1)
	if area is HitboxComponent:
		var hitbox : HitboxComponent = area
		
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		attack.knockback_force = knockback_force
		attack.stun_time = stun_time
		attack.heal = heal
		attack.attack_position = global_position
		
		hitbox.damage(attack)
