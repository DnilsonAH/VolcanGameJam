extends CharacterBody2D

@onready var animationEnemy: AnimationPlayer = $AnimationPlayer
@onready var sprite2D: Sprite2D = $Sprite2D
@onready var hurtBox: Area2D = $Area2D

const SPEED = 400.0
var player: Node2D = null
var has_attacked := false
var attack_cooldown: SceneTreeTimer = null
var spawn_position: Vector2

func _ready():
	spawn_position = global_position

	await get_tree().create_timer(0.1).timeout
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
		if player.has_signal("respawned"):
			player.respawned.connect(_on_player_respawned)
	else:
		print("⚠️ No se encontró el jugador.")

	if hurtBox:
		hurtBox.body_entered.connect(_on_hurt_area_body_entered)

func _physics_process(delta: float) -> void:
	if player == null or has_attacked:
		return

	var direction = (player.global_position - global_position).normalized()
	velocity = direction * SPEED

	sprite2D.flip_h = direction.x < 0
	animationEnemy.play("fly")

	move_and_slide()

func _on_hurt_area_body_entered(body):
	if body.is_in_group("player") and not has_attacked:
		has_attacked = true
		if body.has_method("damage"):
			body.damage(3)
			print("👻 El fantasma atacó y quitó 3 corazones.")
			attack_cooldown = get_tree().create_timer(2.0)
			attack_cooldown.timeout.connect(_reset_attack)

func _reset_attack():
	has_attacked = false
	attack_cooldown = null

func _on_player_respawned():
	global_position = spawn_position
	has_attacked = false
