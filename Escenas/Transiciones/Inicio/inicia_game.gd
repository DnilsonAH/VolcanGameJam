extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	await get_tree().create_timer(2.0).timeout

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://Escenas/Game/Place/escena1_plaza.tscn")
		#get_tree().change_scene_to_file("res://Escenas/Game/Library/escena2_biblioteca.tscn")
		
	pass
