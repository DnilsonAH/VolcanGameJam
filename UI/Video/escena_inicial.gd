extends Control

@onready var videoInicial: VideoStreamPlayer = $VideoStreamPlayer

func _ready() -> void:
	videoInicial.play()
	await videoInicial.finished
	continuar_a_juego()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		videoInicial.stop()
		continuar_a_juego()

func continuar_a_juego() -> void:
	var game = get_node_or_null("/root/GAME")
	if game:
		game.siguiente_nivel = "mundo1"
		game._verificar_nivel()
	else:
		print("⚠ No se encontró el nodo GAME.")
