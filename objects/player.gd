extends RigidBody2D

const WALK_ANIMATION = "walk"
const IDLE_ANIMATION = "idle"

@export var speed = 400
@export var jump_force = -500
@export var is_jumping = false

var velocity = Vector2.ZERO
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	
func _physics_process(_delta):
		velocity = Vector2.ZERO
		
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_just_released('jump'):
			self.apply_impulse(Vector2(0, jump_force))
			is_jumping = true
			
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
			$AnimatedSprite2D.play()
			
		# Update position
		position += velocity * _delta
			
		# Update animation
		if velocity.x != 0:
			if !is_jumping:
				$AnimatedSprite2D.animation = WALK_ANIMATION
			else:
				pass
			$AnimatedSprite2D.flip_h = velocity.x < 0
		else:
			$AnimatedSprite2D.animation = IDLE_ANIMATION

func _on_area_2d_body_entered(body):
	if body is TileMap:
		is_jumping = false
