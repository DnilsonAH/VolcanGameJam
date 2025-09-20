extends CharacterBody2D


const WALK_SPEED = 250.0
const RUN_SPEED = 500
const JUMP_VELOCITY = -350.0

@onready var animationPlayer= $AnimationPlayer

@onready var sprite2D = $Sprite2D

func _physics_process(delta: float) -> void:
	# Gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Salto
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var current_speed = WALK_SPEED
	if Input.is_action_pressed("shift_left"):
		current_speed = RUN_SPEED
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)

	
	move_and_slide()

	animations(direction)

#Flip hacia donde mira el personaje
	if direction == 1:
		sprite2D.flip_h = false
	elif direction == -1:
		sprite2D.flip_h = true

func animations(direction):
	if is_on_floor():
		if direction == 0:
			animationPlayer.play("Idle")
		else:
			animationPlayer.play("Walk")
	else:
		if velocity.y<0:
			animationPlayer.play("Walk")
		elif velocity.y>0:
			animationPlayer.play("Walk")
