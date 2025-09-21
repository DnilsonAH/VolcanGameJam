extends Node2D

@onready var GAME = $"."
@onready var animacion = $AnimationPlayer

var siguiente_nivel

var mundo1 = preload("res://Escenas/Game/Place/escena1_plaza.tscn").instantiate()
var mundo2 = preload("res://Escenas/Game/Library/escena2_biblioteca.tscn").instantiate()

func _ready():
	GAME.add_child(mundo1)
	
func _verificar_nivel():
	match siguiente_nivel:
		"escena2_biblioteca":
			siguiente_nivel = mundo2
	animacion.play("saliendo")

func _siguiente_nivel():
	var nivel = siguiente_nivel
	GAME.add_child(nivel)
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "saliendo":
		$AnimationPlayer.play("entrando")
	if anim_name == "emtrando":
		_siguiente_nivel()
