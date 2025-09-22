extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		var game = get_tree().get_nodes_in_group("GAME")[0]
		game.siguiente_nivel = "flashback"
		game._verificar_nivel()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var game = get_tree().get_nodes_in_group("GAME")[0]
		game.siguiente_nivel = "flashback"
		game._verificar_nivel()
