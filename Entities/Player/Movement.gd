extends CharacterBody2D

const SPEED = 250.0
#const JUMP_VELOCITY = -400.0

@onready var animationPlayer = $AnimationPlayer
@onready var sprite2D = get_node("Sprite2D")


func _physics_process(delta: float) -> void:
	# Movimiento horizontal
	var direction_X := Input.get_axis("ui_left", "ui_right")
	if direction_X:
		velocity.x = direction_X * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Movimiento vertical
	var direction_Y := Input.get_axis("ui_up", "ui_down")
	if direction_Y:
		velocity.y = direction_Y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	# Animaciones
	animations(direction_X, direction_Y)
	

	# Movimiento físico
	move_and_slide()
	#Flip hacia donde mira el personaje
	if direction_X == 1:
		sprite2D.flip_h = false
	elif direction_X == -1:
		sprite2D.flip_h = true

func animations(dx, dy):
	if dx == 0 and dy == 0:
		animationPlayer.play("Idle")
	else:
		animationPlayer.play("Walk")
