extends CharacterBody2D

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

var is_walking := false
var walk_speed := 100.0
var target_position: Vector2

func _ready():
	# Comenzar oculto
	visible = false
	# Agregar al grupo para que sea fácil de encontrar
	add_to_group("mariano_walking")
	print("Mariano caminando listo y en grupo")

func _physics_process(delta):
	if is_walking:
		var direction = (target_position - global_position).normalized()
		velocity = direction * walk_speed
		
		# Voltear el sprite según la dirección
		if direction.x < 0:
			scale.x = -1
		elif direction.x > 0:
			scale.x = 1
		
		if global_position.distance_to(target_position) < 10.0:
			stop_walking()
		else:
			move_and_slide()

func start_walking():
	is_walking = true
	visible = true
	# Usar la animación que tienes disponible
	if animationPlayer.has_animation("Walk_anciano"):
		animationPlayer.play("Walk_anciano")
		print("Reproduciendo animación Walk_anciano")

func stop_walking():
	is_walking = false
	velocity = Vector2.ZERO
	# No hay animación idle, así que detener la animación actual
	animationPlayer.stop()
	print("Mariano se ha detenido")

func set_walk_target(new_target: Vector2, speed: float = 100.0):
	target_position = new_target
	walk_speed = speed
	print("Target establecido en: ", target_position, " con velocidad: ", speed)
	start_walking()
