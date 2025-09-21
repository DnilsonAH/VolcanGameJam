extends CharacterBody2D
class_name Enemy

@onready var animationEnemy = $AnimationPlayer
@onready var sprite2D = $Sprite2D

const SPEED = 250.0
var player = null



func _ready():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	
	

func _physics_process(delta: float) -> void:
	if player != null:
		var direction = (player.global_position - global_position).normalized()
		self.velocity = direction * SPEED
		sprite2D.flip_h = direction.x < 0
		animationEnemy.play("Walk")
		move_and_slide()
		#var collision = move_and_collide(velocity * delta)
		#if collision:
		#	animationEnemy.play("Walk")
		#else:
		#	animationEnemy.play("Walk")
	
