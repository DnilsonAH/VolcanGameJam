extends CharacterBody2D

@onready var animationEnemy = $AnimationPlayer
@onready var sprite2D = $Sprite2D

const SPEED = 150.0
var player: Node2D = null

func _ready():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]

func _physics_process(delta: float) -> void:
	if player == null:
		return

	# Dirección hacia el jugador
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * SPEED

	# Voltear sprite según dirección horizontal
	sprite2D.flip_h = direction.x < 0

	# Animación
	animationEnemy.play("Float")

	# Movimiento con colisiones
	move_and_slide()
