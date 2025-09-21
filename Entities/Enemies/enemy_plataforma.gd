extends CharacterBody2D
class_name EnemyPlatform

@onready var animationEnemy = $AnimationPlayer
@onready var sprite2D = $Sprite2D
@onready var raycast = $RayCast2D  # Para detectar suelo delante

const SPEED = 250.0
const GRAVITY = 980.0
const JUMP_FORCE = -400.0

var direction := -1  # -1 = izquierda, 1 = derecha

func _physics_process(delta: float) -> void:
	# Aplicar gravedad
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0

	# Movimiento horizontal
	velocity.x = direction * SPEED

	# Voltear sprite
	sprite2D.flip_h = direction < 0

	# Animaciones
	if is_on_floor():
		animationEnemy.play("Walk")
	else:
		animationEnemy.play("Jump")

	# Saltar si no hay suelo delante
	if is_on_floor() and not raycast.is_colliding():
		velocity.y = JUMP_FORCE

	# Mover con colisiones
	move_and_slide()

	# Cambiar dirección si choca lateralmente
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if abs(collision.get_normal().x) > 0.9:
			direction *= -1
