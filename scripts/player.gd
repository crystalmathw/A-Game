extends CharacterBody2D


const SPEED = 130.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer


var playerHealth: float = 100
var lastDirection: float = 0

func dead() -> void:
	animated_sprite.play("death")
	Engine.time_scale = 0.5
	timer.start()
	
func playerTakeDamage(damage: float):
	playerHealth = playerHealth - damage
	
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
	
	# Horisontal movement
	if direction_x:
		velocity.x = direction_x * SPEED
		lastDirection = 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	#Vertical movement
	if direction_y:
		velocity.y = direction_y * SPEED
		lastDirection = direction_y
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	

	move_and_slide()

func _physics_process(delta: float) -> void:
	if playerHealth > 0:
		movement()
	else:
		dead()

func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
