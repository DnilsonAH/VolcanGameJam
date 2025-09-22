extends Control

@onready var musica: AudioStreamPlayer = $AudioStreamPlayer
var musica_de_gamplay = preload("res://Assets/Sounds/Musica nostalgia 8 bit.mp3")

func _ready() -> void:
	musica.stream = musica_de_gamplay
	musica.play()

func _on_play_pressed() -> void:
	# Carga el sistema de juego, no la escena jugable directamente
	get_tree().change_scene_to_file("res://Main/game.tscn")

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Menu/Credits.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()

func _inputPause(event: InputEvent) -> void:
	if event.is_action_pressed("ui_letter_p"):
		musica.stream_paused = !musica.stream_paused
