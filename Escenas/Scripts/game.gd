extends Node2D

@onready var GAME = $"."
@onready var animacion = $AnimationPlayer

var siguiente_nivel : String = ""

# ✅ Solo preload de PackedScene (sin instantiate aquí)
var mundo1_scene = preload("res://Escenas/Game/Place/escena1_plaza.tscn")
var mundo2_scene = preload("res://Escenas/Game/Library/escena2_biblioteca.tscn")
var mundo3_scene = preload("res://Escenas/Game/LevelCampo/LevelCampo.tscn")
var mundo4_scene = preload("res://Escenas/Game/Library/derecha.tscn")

func _ready():
	add_to_group("GAME") # 👈 importante para que escena1_plaza lo encuentre
	var mundo1 = mundo1_scene.instantiate()
	mundo1.add_to_group("escena1_plaza")
	GAME.add_child(mundo1)

func _verificar_nivel():
	animacion.play("saliendo")

func _siguiente_nivel():
	var nivel
	match siguiente_nivel:
		"mundo1":
			nivel = mundo1_scene.instantiate()
			nivel.add_to_group("escena1_plaza")
		"mundo2":
			nivel = mundo2_scene.instantiate()
			nivel.add_to_group("escena2_biblioteca")
		"mundo3":
			nivel = mundo3_scene.instantiate()
			nivel.add_to_group("escena_derecha")
		"mundo4":
			nivel = mundo4_scene.instantiate()
			nivel.add_to_group("escena_izquierda")
		_:
			print("⚠ Nivel no reconocido: ", siguiente_nivel)
			return
	
	GAME.add_child(nivel)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "saliendo":
		animacion.play("entrando")
	elif anim_name == "entrando": # 👈 corregido
		_siguiente_nivel()
