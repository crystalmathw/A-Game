extends CharacterBody2D

@export var SPEED: float = 25

@onready var character: CharacterBody2D = self
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var health: HealthComponent = $HealthComponent
@onready var hit_timer: Timer = $HitTimer
@onready var restart_timer: Timer = $RestartTimer
@onready var attack_timer: Timer = $AttackTimer

var lastDirection: float = 0
var startingPosition: Vector2
var zIndex: int
var attacking: bool = false

func _ready() -> void:
	health.connect("take_damage", Callable(self, "_damage_taken"))
	health.connect("is_dead", Callable(self, "_died"))
	hit_timer.connect("timeout", Callable(self, "_on_hit_timer_timeout"))
	restart_timer.connect("timeout", Callable(self, "_on_restart_timer_timeout"))
	attack_timer.connect("timeout", Callable(self, "_on_attack_timer_timeout"))
	startingPosition = character.position

func _physics_process(_delta: float) -> void:
	character.z_index = int(global_position.y)
	movement()

func movement() -> void:# Movement and animations
	var direction_x := 0 #dynamic change by ai stuff
	var direction_y := 0
	
	# Flip the sprite
	if direction_x > 0:
		animated_sprite.flip_h = false
	elif direction_x < 0:
		animated_sprite.flip_h = true
	
	# Play animations
	if direction_x == 0 and direction_y == 0:
		if lastDirection == 0:
			animated_sprite.play("idle_horizontal")
		elif lastDirection == -1:
			animated_sprite.play("idle_up")
		else:
			animated_sprite.play("idle_down")
	else:
		if direction_y < 0:
			animated_sprite.play("run_up" if direction_x == 0 else "run_horizontal_up")
		elif direction_y > 0:
			animated_sprite.play("run_down" if direction_x == 0 else "run_horizontal_down")
		else:
			animated_sprite.play("run_horizontal")


	var direction = Vector2(direction_x, direction_y)
	if direction.length() > 0:
		direction = direction.normalized()
		velocity = direction * SPEED
		if direction_x != 0:
			lastDirection = 0
		elif direction_y != 0:
			lastDirection = direction_y
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

func attack() -> void:
	#attack scipt
	
	attacking = true
	attack_timer.start()

func _on_attack_timer_timeout() -> void:
	attacking = false

func _damage_taken():
	animated_sprite.modulate = Color(1, 0, 0, 1)
	hit_timer.start()
	
func _on_hit_timer_timeout() -> void:
	animated_sprite.modulate = Color(1, 1, 1, 1)

func _died() -> void:
	animated_sprite.play("death")
	set_physics_process(false)
	restart_timer.start()

func _on_restart_timer_timeout() -> void:
	character.position = startingPosition
	health.reset()
	animated_sprite.play("idle")
	set_physics_process(true)
