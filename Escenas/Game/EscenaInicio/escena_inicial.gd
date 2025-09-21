extends Control

@onready var videoInicial: VideoStreamPlayer = $VideoStreamPlayer

func _ready() -> void:
	videoInicial.play()
	# Esperar a que el video termine
	await videoInicial.finished
	_cambiar_escena()

func _process(delta: float) -> void:
	# Permitir que el jugador salte el video con Enter o cualquier acción definida como "ui_accept"
	if Input.is_action_just_pressed("ui_accept"):
		videoInicial.stop()
		_cambiar_escena()

func _cambiar_escena() -> void:
	# En lugar de cambiar directamente a escena1_plaza, cambiamos a game.tscn
	# que ya tiene la lógica para manejar las transiciones
	get_tree().change_scene_to_file("res://Escenas/Main/game.tscn")
