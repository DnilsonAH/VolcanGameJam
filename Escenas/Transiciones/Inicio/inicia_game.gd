extends Control

@export_file("*.tscn") var game_scene = "res://Escenas/Main/game.tscn"
var cambio_realizado := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Espera 2 segundos y luego cambia al GAME
	await get_tree().create_timer(2.0).timeout
	_cambiar_a_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Si el jugador presiona Enter, se salta la historia
	if Input.is_action_just_pressed("ui_accept"):
		_cambiar_a_game()
	
func _cambiar_a_game() -> void:
	if not cambio_realizado:
		cambio_realizado = true
		get_tree().change_scene_to_file(game_scene)
