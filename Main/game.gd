extends Node2D

@onready var animacion = $AnimationPlayer

var siguiente_nivel : String = ""
var escena_actual: Node = null
var respawn_position: Vector2 = Vector2.ZERO

# Escenas precargadas
var mundo1_scene = preload("res://Escenes/PlaceEscene/escena1_plaza.tscn")
var mundo2_scene = preload("res://Escenes/LibraryEscene/escena2_biblioteca.tscn")
var mundo3_scene = preload("res://Escenes/CampoEscene/LevelCampo.tscn")
var mundo4_scene = preload("res://Escenes/LibraryEscene/derecha.tscn")
var flashback_scene = preload("res://UI/flashbacks/primer_flash_back.tscn")
var antes_biblioteca = preload("res://UI/flashbacks/antes_biblioteca.tscn")

func get_respawn_position() -> Vector2:
	return respawn_position

func _ready():
	add_to_group("GAME")
	$CanvasLayer/ColorRect.visible = false   # 👈 arranca apagado
	var mundo1 = mundo1_scene.instantiate()
	mundo1.add_to_group("escena1_plaza")
	escena_actual = mundo1
	self.add_child(mundo1)

	await get_tree().create_timer(0.1).timeout  # Esperar a que el jugador se instancie
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		respawn_position = players[0].global_position
	else:
		print("⚠ No se encontró el jugador para guardar posición de respawn.")

func _verificar_nivel():
	if siguiente_nivel == "":
		print("⚠ No se ha definido el siguiente nivel.")
		return

	var overlay = $CanvasLayer/ColorRect
	overlay.visible = true    # 👈 se activa recién ahora
	animacion.play("saliendo")

func _siguiente_nivel():
	print("Cambiando al nivel: ", siguiente_nivel)

	if escena_actual != null:
		escena_actual.queue_free()
		escena_actual = null

	var nivel: Node = null
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
		"flashback":
			nivel = flashback_scene.instantiate()
			nivel.add_to_group("flashback")
		"antes_biblioteca":
			nivel = antes_biblioteca.instantiate()
			nivel.add_to_group("antes_biblioteca")
		_:
			print("⚠ Nivel no reconocido: ", siguiente_nivel)
			return

	escena_actual = nivel
	self.add_child(nivel)

	await get_tree().create_timer(0.1).timeout
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		respawn_position = players[0].global_position
	else:
		print("⚠ No se encontró el jugador en la nueva escena.")

	print("✅ Nivel cambiado exitosamente.")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "saliendo":
		_siguiente_nivel()
		animacion.play("entrando")
	elif anim_name == "entrando":
		$CanvasLayer/ColorRect.visible = false   # 👈 ocultar otra vez
