extends Node2D

func _on_siguiente_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		var game = get_tree().get_nodes_in_group("GAME")[0]
		game.siguiente_nivel = "mundo2"
		game._verificar_nivel()

func _on_siguiente_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var game = get_tree().get_nodes_in_group("GAME")[0]
		game.siguiente_nivel = "mundo2"
		game._verificar_nivel()
