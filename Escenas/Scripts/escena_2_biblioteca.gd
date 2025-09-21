extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_izquierda_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		var game = get_tree().get_nodes_in_group("GAME")[0]
		game.siguiente_nivel = "mundo3"
		game._verificar_nivel()
		get_tree().get_nodes_in_group("escena2_biblioteca")[0].queue_free()


func _on_izquierda_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var game = get_tree().get_nodes_in_group("GAME")[0]
		game.siguiente_nivel = "mundo3"
		game._verificar_nivel()
		get_tree().get_nodes_in_group("escena2_biblioteca")[0].queue_free()


func _on_derecha_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		var game = get_tree().get_nodes_in_group("GAME")[0]
		game.siguiente_nivel = "mundo4"
		game._verificar_nivel()
		get_tree().get_nodes_in_group("escena2_biblioteca")[0].queue_free()


func _on_derecha_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var game = get_tree().get_nodes_in_group("GAME")[0]
		game.siguiente_nivel = "mundo4"
		game._verificar_nivel()
		get_tree().get_nodes_in_group("escena2_biblioteca")[0].queue_free()
