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
	get_tree().change_scene_to_file("res://Main/game.tscn")
