extends CharacterBody2D


const WALK_SPEED = 200.0
const RUN_SPEED = 350
const JUMP_VELOCITY = -450.0
var Hearts = 3
var is_damaged = false

const IsPincho = "res://Entities/DagameTileMap/pinchos_tile_map.tscn"

@onready var animationPlayer= $AnimationPlayer
@onready var sprite2D = $Sprite2D
@onready var hurtBox = $Area2D

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
		
		
func _ready():
	if hurtBox:
		hurtBox.body_entered.connect(_on_hurt_area_body_entered)
		hurtBox.area_entered.connect(_on_hurt_area_area_entered)
	else:
		print("⚠️ Nodo HurtArea2D no encontrado.")


#Animaciones
func animations(direction):
	if is_damaged:
		return  # No reproducir otras animaciones mientras está dañado
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

#Vidas


#Interacciones
#Daño si el personaje toca un objeto pincho
func _on_hurt_area_body_entered(body):
	if body.is_in_group("dañino"):
		damage()

# Nueva función para detectar colisiones con áreas
func _on_hurt_area_area_entered(area):
	if area.is_in_group("dañino"):
		damage()

func damage():
	if is_damaged:
		return
	is_damaged = true
	Hearts -= 1
	animationPlayer.play("damage")
	print("¡Daño recibido! Vidas restantes: ", Hearts)

	if Hearts <= 0:
		die()
	else:
		await get_tree().create_timer(0.5).timeout
		is_damaged = false

func die():
	print("¡Has muerto!")
	queue_free()  # Elimina al personaje
