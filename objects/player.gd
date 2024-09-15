extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -500.0
var on_ladder = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Animações
const IDLE_ANIMATION = "idle"
const WALK_ANIMATION = "walk"
const JUMP_ANIMATION = "jump"
const CLIMB_ANIMATION = "climb"

func _ready():
	# Conectar sinais do Area2D (LadderDetector)
	$LadderDetector.connect("body_entered", self._on_area_2d_body_entered)
	$LadderDetector.connect("body_exited", self._on_area_2d_body_exited)

# Detecta quando o personagem entra na área da escada
func _on_area_2d_body_entered(body):
	if body.name == "LadderDetector":
		on_ladder = true

# Detecta quando o personagem sai da área da escada
func _on_area_2d_body_exited(body):
	if body.name == "LadderDetector":
		on_ladder = false

func _physics_process(delta):
	# Adiciona a gravidade se não estiver na escada
	if not is_on_floor() and not on_ladder:
		velocity.y += gravity * delta

	# Movimento na escada
	if on_ladder:
		if Input.is_action_pressed("ui_up"):
			velocity.y = -SPEED
			$AnimatedSprite2D.animation = CLIMB_ANIMATION
		elif Input.is_action_pressed("ui_down"):
			velocity.y = SPEED
			$AnimatedSprite2D.animation = CLIMB_ANIMATION
		else:
			velocity.y = 0
			$AnimatedSprite2D.animation = CLIMB_ANIMATION
	else:
		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Pegar a direção de entrada e lidar com a movimentação e desaceleração
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
			$AnimatedSprite2D.animation = WALK_ANIMATION
			$AnimatedSprite2D.flip_h = velocity.x < 0
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		# Verifica se está no ar para animação de pulo
		if velocity.y != 0:
			$AnimatedSprite2D.animation = JUMP_ANIMATION
			$AnimatedSprite2D.flip_h = velocity.x < 0
		else:
			$AnimatedSprite2D.animation = IDLE_ANIMATION

	move_and_slide()

