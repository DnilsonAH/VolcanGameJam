extends CharacterBody2D

const WALK_SPEED = 200.0
const RUN_SPEED = 350
const JUMP_VELOCITY = -450.0
var Hearts = 3
var is_damaged = false
var is_dead = false
var is_touching_dañino := false  # ✅ evita daño repetido mientras está encima

@onready var animationHeart = $Corazones/AnimationPlayer
@onready var animationPlayer = $AnimationPlayer
@onready var sprite2D = $Sprite2D
@onready var hurtBox = $Area2D

func _ready():
	if hurtBox:
		hurtBox.body_entered.connect(_on_hurt_area_body_entered)
		hurtBox.area_entered.connect(_on_hurt_area_area_entered)
		hurtBox.body_exited.connect(_on_hurt_area_body_exited)
		hurtBox.area_exited.connect(_on_hurt_area_area_exited)
	else:
		print("⚠️ Nodo HurtArea2D no encontrado.")
	heart(Hearts)

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var current_speed = WALK_SPEED
	if Input.is_action_pressed("shift_left"):
		current_speed = RUN_SPEED
	
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
		animationPlayer.play("Jump")

# Interacciones
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

# Daño
func damage():
	if is_damaged or is_dead:
		return
	is_damaged = true
	Hearts -= 1
	animationPlayer.play("damage")
	print("¡Daño recibido! Vidas restantes: ", Hearts)
	heart(Hearts)

	if Hearts <= 0:
		die()
	else:
		await get_tree().create_timer(0.5).timeout
		is_damaged = false

# Muerte
func die():
	if is_dead:
		return
	is_dead = true
	print("💀 ¡Has muerto!")
	animationPlayer.play("die")
	heart(0)

	await get_tree().create_timer(1.5).timeout
	get_tree().reload_current_scene()

# Corazones visuales
func heart(num):
	match num:
		3: animationHeart.play("tresCorazones")
		2: animationHeart.play("dosCorazones")
		1: animationHeart.play("unCorazon")
		0: animationHeart.play("dieCorazon")
