extends RigidBody2D

class_name Player

const WALK_ANIMATION = "walk"
const IDLE_ANIMATION = "idle"
const JUMP_ANIMATION = "jump"

@export var life = 3
@export var retries = 2

@export var speed = 400
@export var jump_force = -700

@export var SpwanPosition: Node2D

var velocity = Vector2.ZERO
var is_taking_damage = false
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	position = SpwanPosition.position
	
func _process(delta):
	pass
	
func _physics_process(_delta):
		velocity = Vector2.ZERO
		
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_just_released('jump') and linear_velocity.y == 0:
			self.apply_impulse(Vector2(0, jump_force))
			
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
			$AnimatedSprite2D.play()
			
		# Update position
		position += velocity * _delta
			
		# Update animation
		if velocity.x != 0 and linear_velocity.y == 0:
			$AnimatedSprite2D.animation = WALK_ANIMATION
			$AnimatedSprite2D.flip_h = velocity.x < 0
		elif linear_velocity.y != 0:
			$AnimatedSprite2D.animation = JUMP_ANIMATION
			$AnimatedSprite2D.flip_h = velocity.x < 0
		else:
			$AnimatedSprite2D.animation = IDLE_ANIMATION


func take_damage(body: Node2D):
	if (!is_taking_damage and body is Spikes):
		life -= 1
		is_taking_damage = true
		if (life == 0):
			$RecoveryTimer.stop()
			reset_player()
		else:
			$RecoveryTimer.start()
				
func reset_player():
	position = SpwanPosition.position
	is_taking_damage = false
	life = 3
	if retries == 0:
		retries = 2
	else:
		retries-=1

func _on_recovery_timer_timeout():
	is_taking_damage = false
