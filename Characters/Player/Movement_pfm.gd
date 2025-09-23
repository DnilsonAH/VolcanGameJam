extends CharacterBody2D

signal respawned

# Constantes de movimiento
const WALK_SPEED = 500.0
const RUN_SPEED = 600.0
const JUMP_VELOCITY = -475.0

# Variables de salud y estado
var Hearts = 3
var is_damaged = false
var is_dead = false
var is_touching_dañino := false

# Variables para seguir a Mariano
var following_character: CharacterBody2D = null
var is_following := false

# Referencias de nodos
@onready var animationHeart = $Corazones/AnimationPlayer
@onready var animationPlayer = $AnimationPlayer
@onready var sprite2D = $Sprite2D
@onready var hurtBox = $Area2D

func _ready():
	add_to_group("player")
	if hurtBox:
		hurtBox.body_entered.connect(_on_hurt_area_body_entered)
		hurtBox.area_entered.connect(_on_hurt_area_area_entered)
		hurtBox.body_exited.connect(_on_hurt_area_body_exited)
		hurtBox.area_exited.connect(_on_hurt_area_area_exited)
	heart(Hearts)

# Función para que Mariano active el seguimiento
func follow_character(character: CharacterBody2D):
	following_character = character
	is_following = true
	print("¡Sigue a Mariano! El camino continúa hacia la derecha.")

# Función para obtener dirección hacia Mariano
func get_direction_to_mariano() -> Vector2:
	if following_character:
		return (following_character.global_position - global_position).normalized()
	return Vector2.ZERO

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	# Verificar si el personaje seguido dejó de moverse
	if is_following and following_character:
		if following_character.has_method("is_character_walking"):
			if not following_character.is_character_walking():
				is_following = false
				following_character = null
				print("Mariano se ha detenido.")
	
	# Gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Salto
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Velocidad (caminar/correr)
	var current_speed = WALK_SPEED
	if Input.is_action_pressed("shift_left"):
		current_speed = RUN_SPEED
	
	# Movimiento horizontal
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
	
	move_and_slide()
	animations(direction)
	sprite2D.flip_h = direction < 0

func animations(direction):
	if is_damaged or is_dead:
		return
	if is_on_floor():
		if direction == 0:
			animationPlayer.play("Idle")
		else:
			animationPlayer.play("Walk")
	else:
		animationPlayer.play("Walk")

# Funciones de daño
func _on_hurt_area_body_entered(body):
	if body.is_in_group("dañino") and not is_touching_dañino:
		is_touching_dañino = true
		damage()

func _on_hurt_area_area_entered(area):
	if area.is_in_group("dañino") and not is_touching_dañino:
		is_touching_dañino = true
		damage()

func _on_hurt_area_body_exited(body):
	if body.is_in_group("dañino"):
		is_touching_dañino = false

func _on_hurt_area_area_exited(area):
	if area.is_in_group("dañino"):
		is_touching_dañino = false

func damage(amount := 1):
	if is_damaged or is_dead:
		return
	is_damaged = true
	Hearts -= amount
	animationPlayer.play("damage")
	print("¡Daño recibido! Vidas restantes: ", Hearts)
	heart(Hearts)
	if Hearts <= 0:
		die()
	else:
		await get_tree().create_timer(0.5).timeout
		is_damaged = false

func die():
	if is_dead:
		return
	is_dead = true
	print("💀 ¡Has muerto!")
	animationPlayer.play("die")
	heart(0)
	await get_tree().create_timer(1.5).timeout
	emit_signal("respawned")
	var games = get_tree().get_nodes_in_group("GAME")
	if games.size() > 0:
		var game = games[0]
		global_position = game.get_respawn_position()
	else:
		print("⚠ No se encontró el nodo GAME.")
	Hearts = 3
	is_dead = false
	is_damaged = false
	# Resetear el seguimiento al respawnear
	is_following = false
	following_character = null
	heart(Hearts)
	animationPlayer.play("Idle")

func heart(num):
	match num:
		3: animationHeart.play("tresCorazones")
		2: animationHeart.play("dosCorazones")
		1: animationHeart.play("unCorazon")
		0: animationHeart.play("dieCorazon")
