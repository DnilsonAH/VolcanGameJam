extends Control

var isEsceneRutes = [
	"res://Resources/EscenasTrantitions/HistoriaInicial/escena1.png", 
	"res://Resources/EscenasTrantitions/HistoriaInicial/escena2.png",
]

@onready var isEscenes = $TextureEscena

func _ready() -> void:
	#await show_image_sequence()
	
	#isEscenes.texture = load(route)
	await get_tree().create_timer(7.0).timeout

func show_image_sequence():
	for route in isEsceneRutes:
		isEscenes.texture = load(route)
		await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://Escenas/Transiciones/Inicio/Inicia_Game.tscn")
	
