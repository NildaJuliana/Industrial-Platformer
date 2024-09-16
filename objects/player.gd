extends CharacterBody2D

# Constantes e variáveis
const SPEED = 400.0
const JUMP_VELOCITY = -550.0
const CLIMB_SPEED = 200.0  # Velocidade de escalada

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_on_ladder = false  # Indica se o personagem está na escada

# Conectar os sinais
func _ready():
	var ladder_detector = get_node("/root/World/LadderDetector")  # Ajuste conforme necessário
	ladder_detector.connect("body_entered", self._on_ladder_detector_body_entered)
	ladder_detector.connect("body_exited", self._on_ladder_detector_body_exited)

# Função chamada quando o corpo entra na área da escada
func _on_ladder_detector_body_entered(body):
	if body == self:
		is_on_ladder = true  # Ativa o modo de escalada quando entrar na escada

# Função chamada quando o corpo sai da área da escada
func _on_ladder_detector_body_exited(body):
	if body == self:
		is_on_ladder = false  # Desativa o modo de escalada ao sair da escada


# Função para detectar inputs e mover o personagem
func _physics_process(delta):
	if is_on_ladder:
		ClimbLadder()
	else:
		NormalMovement(delta)

# Lógica de movimento normal (andar e pular)
func NormalMovement(delta):
	# Adiciona a gravidade
	if not is_on_floor():
		velocity.y += gravity * delta

	# Lógica de pulo
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Lógica de movimento horizontal
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# Atualiza a animação
	UpdateAnimation()

# Lógica de escalada
func ClimbLadder():
	# Desativa a gravidade enquanto estiver escalando
	velocity.y = 0

	# Detecta input de subir ou descer
	var direction = Input.get_axis("ui_up", "ui_down")
	
	# Escalar para cima ou para baixo
	if direction != 0:
		velocity.y = direction * CLIMB_SPEED
	else:
		velocity.y = 0  # Parar na escada se não houver direção

	# Se sair da escada por baixo (atingir o chão), voltar ao movimento normal
	if not is_on_ladder and is_on_floor():
		is_on_ladder = false
		velocity.x = 0  # Resetar a velocidade horizontal ao descer a escada
		return  # Sair da função

	# Aplica o movimento vertical da escada
	move_and_slide()

	# Atualiza a animação de escalada
	$AnimatedSprite2D.animation = "climb"



# Função para atualizar a animação de andar/pular/escalar
func UpdateAnimation():
	if is_on_ladder:
		$AnimatedSprite2D.animation = "climb"
		$AnimatedSprite2D.flip_h = false  # Evitar espelhar durante a escalada
	elif velocity.y != 0 and not is_on_ladder:
		$AnimatedSprite2D.animation = "jump"
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_h = velocity.x < 0  # Atualiza a orientação do sprite
	else:
		$AnimatedSprite2D.animation = "idle"



