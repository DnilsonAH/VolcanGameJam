extends Control

@onready var videoInicial = $VideoStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	videoInicial.play()
	video_pause()
	
	
	
	
	pass # Replace with function body.
	
#func _process(delta: float) -> void:
#	if Input.is_action_just_pressed("ui_accept"):
#		videoInicial.stop()
#		get_tree().change_scene_to_file("res://Escenas/Game/Place/escena1_plaza.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func video_pause():
	await get_tree().create_timer(7.5).timeout
	get_tree().change_scene_to_file("res://Escenas/Game/Place/escena1_plaza.tscn")
