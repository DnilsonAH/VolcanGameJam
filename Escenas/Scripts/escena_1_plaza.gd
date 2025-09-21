extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_siguiente_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		var games = get_tree().get_nodes_in_group("GAME")
		if games.size() > 0:
			var game = games[0]
			game.siguiente_nivel = "mundo2"
			game._verificar_nivel()
			# NO eliminar la escena aquí, dejar que game.gd lo haga

func _on_siguiente_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var games = get_tree().get_nodes_in_group("GAME")
		if games.size() > 0:
			var game = games[0]
			game.siguiente_nivel = "mundo2"
			game._verificar_nivel()
			# NO eliminar la escena aquí, dejar que game.gd lo haga
