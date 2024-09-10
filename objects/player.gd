extends RigidBody2D

const WALK_ANIMATION = "walk"
const IDLE_ANIMATION = "idle"

@export var speed = 400
@export var is_kumping = false

var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	
func _physics_process(_delta):
		var velocity = Vector2.ZERO
		
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
			
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
			$AnimatedSprite2D.play()
			
		position += velocity * _delta
		position = position.clamp(Vector2.ZERO, screen_size)
			
		if velocity.x != 0:
			$AnimatedSprite2D.animation = WALK_ANIMATION
			$AnimatedSprite2D.flip_h = velocity.x < 0
		else:
			$AnimatedSprite2D.animation = IDLE_ANIMATION

func _on_area_2d_body_entered(body):
	if body is TileMap:
		pass
