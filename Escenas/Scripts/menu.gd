extends Control

@onready var musica: AudioStreamPlayer = $AudioStreamPlayer

var musica_de_gamplay = preload("res://Resources/Songs/Musica nostalgia 8 bit.mp3")

#Botones del menu
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/Game/EscenaInicio/EscenaInicial.tscn")
	#get_tree().change_scene_to_file("res://Escenas/Transiciones/Inicio/HistoriaInicio.tscn")

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/Menu/Credits.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
	
#Funcion de musica play
func _ready() -> void:
	musica.stream = musica_de_gamplay
	musica.play()
	

func _inputPause(event: InputEvent) -> void:
	if event.is_action_pressed("ui_letter_p"):
		if !musica.stream_paused:
			musica.stream_paused = true
		else:
			musica.stream_paused = false
