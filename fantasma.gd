extends CharacterBody2D

@onready var animationEnemy = $AnimationPlayer
@onready var sprite2D = $Sprite2D
@onready var hurtBox = $Area2D

const SPEED = 150.0
var player: Node2D = null
var has_attacked := false

func _ready():
	# Esperar un momento para que el jugador se instancie
	await get_tree().create_timer(0.1).timeout
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	else:
		print("⚠️ No se encontró el jugador en el grupo 'player'.")

	if hurtBox:
		hurtBox.body_entered.connect(_on_hurt_area_body_entered)
	else:
		print("⚠️ El fantasma no tiene Area2D conectada.")

func _physics_process(delta: float) -> void:
	if player == null or has_attacked:
		return

	# Dirección hacia el jugador
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * SPEED

	sprite2D.flip_h = direction.x < 0
	animationEnemy.play("Float")

	move_and_slide()

func _on_hurt_area_body_entered(body):
	if body.is_in_group("player") and not has_attacked:
		has_attacked = true
		if body.has_method("damage"):
			for i in range(3):
				body.damage()
		else:
			print("⚠️ El jugador no tiene método 'damage'.")
