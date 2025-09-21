extends CharacterBody2D

@onready var animationPlayer = $AnimationPlayer
@onready var area = $Area2D

func _ready():
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	animationPlayer.play("Idle")

func _on_body_entered(body):
	if body.name == "Player":
		animationPlayer.play("Talk")
		#get_node("/root/DialogManager").show_dialogue("¡Hola! Bienvenido a la plaza.")


func _on_body_exited(body):
	if body.name == "Player":
		animationPlayer.play("Idle")
