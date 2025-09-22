extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	var game = get_tree().get_first_node_in_group("GAME")
	game.siguiente_nivel = "mundo2"
	game._verificar_nivel()
	queue_free()
