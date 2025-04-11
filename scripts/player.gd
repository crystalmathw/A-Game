extends CharacterBody2D

@export var playerHealth: float = 100
@export var SPEED = 130.0
@export var SPRINT = 2


@onready var player: CharacterBody2D = $"."
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var restart_timer: Timer = $RestartTimer
@onready var hit_timer: Timer = $HitTimer
@onready var death_text: Label = $DeathText
@onready var animation: AnimationPlayer = $AnimationPlayer

var speedMultiplier = 1
var lastDirection: float = 0
var startingPosition: Vector2
var zIndex

func dead() -> void:
	animated_sprite.play("death")
	animation.play("DeathText FadeIn")
	Engine.time_scale = 0.5
	restart_timer.start()
	set_physics_process(false)
	
func _on_restart_timer_timeout() -> void:
	Engine.time_scale = 1
	player.position = startingPosition
	playerHealth = 100
	set_physics_process(true)
	animation.play("DeathText FadeOut")


func playerTakeDamage(damage: float):
	playerHealth = playerHealth - damage
	animated_sprite.modulate = Color(1, 0, 0, 1) 
	hit_timer.start()

func _on_hit_timer_timeout() -> void:
	animated_sprite.modulate = Color(1, 1, 1, 1) 

func getPlayerHealth() -> float:
	return playerHealth


func movement() -> void:
	# Movement and animations
	var direction_x := Input.get_axis("move_left", "move_right")
	var direction_y := Input.get_axis("move_up", "move_down")
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
		if direction_x != 0 and direction_y == 0:
			animated_sprite.play("run_horizontal")
		elif direction_x == 0 and direction_y < 0:
			animated_sprite.play("run_up")
		elif direction_x == 0 and direction_y > 0:
			animated_sprite.play("run_down")
		elif direction_x != 0 and direction_y < 0:
			animated_sprite.play("run_horizontal_up")
		elif direction_x != 0 and direction_y > 0:
			animated_sprite.play("run_horizontal_down")
	
	# Sprinting
	if Input.is_action_pressed("sprint") == true:
		speedMultiplier = SPRINT
	else:
		speedMultiplier = 1
	# Horizontal movement
	if direction_x:
		velocity.x = direction_x * SPEED * speedMultiplier
		lastDirection = 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	#Vertical movement
	if direction_y:
		velocity.y = direction_y * SPEED * speedMultiplier
		lastDirection = direction_y
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	

	move_and_slide()
	
func _ready() -> void:
	startingPosition = player.position
	animation.play("RESET")

func _physics_process(_delta: float) -> void:
	player.z_index = int(player.position.y)
	if playerHealth > 0:
		movement()
	else:
		dead()
		
