extends Control

var isEsceneRutes = [
	"res://Resources/EscenasTrantitions/escena1.png", 
	"res://Resources/EscenasTrantitions/escena2.png",
    "res://Resources/EscenasTrantitions/escena3.png"
]

@onready var isEscenes = $TexturaEscena

func _ready() -> void:
	show_image_sequence()
	get_tree().change_scene_to_file("res://Escenas/Menu/MenuPrincipal.tscn")

func show_image_sequence():
	for route in isEsceneRutes:
		isEscenes.texture = load(route)
		await get_tree().create_timer(2.0).timeout

	# Al final, cambiar a la escena principal (opcional)
	get_tree().change_scene("res://Escenas/Menu/MenuPrincipal.tscn")
