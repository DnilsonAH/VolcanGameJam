extends Node2D

@onready var animacion: AnimationPlayer = $AnimationPlayer
var db := SQLite.new()

var siguiente_nivel: String = ""
var escena_actual: Node = null
var respawn_position: Vector2 = Vector2.ZERO

var escenas := {
	"inicio": preload("res://UI/Video/EscenaInicial.tscn"),
	"mundo1": preload("res://Escenes/PlaceEscene/escena1_plaza.tscn"),
	"mundo2": preload("res://Escenes/LibraryEscene/escena2_biblioteca.tscn"),
	"mundo3": preload("res://Escenes/CampoEscene/LevelCampo.tscn"),
	"mundo4": preload("res://Escenes/LibraryEscene/derecha.tscn")
}

func get_respawn_position() -> Vector2:
	return respawn_position

func _ready():
	add_to_group("GAME")
	_inicializar_sqlite()
	siguiente_nivel = "inicio"
	_cargar_escena(siguiente_nivel)

func _inicializar_sqlite():
	db.path = "user://datos_juego.db"
	db.open_db()
	db.query("CREATE TABLE IF NOT EXISTS estadisticas (muertes INTEGER DEFAULT 0);")

func registrar_muerte():
	db.query("UPDATE estadisticas SET muertes = muertes + 1;")

func obtener_muertes() -> int:
	var result = db.select_rows("SELECT muertes FROM estadisticas;")
	if result.size() > 0:
		return result[0]["muertes"]
	return 0

func _verificar_nivel():
	if siguiente_nivel == "":
		print("⚠ No se ha definido el siguiente nivel.")
		return

	if animacion.has_animation("saliendo"):
		animacion.play("saliendo")
	else:
		_cargar_escena(siguiente_nivel)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "saliendo":
		animacion.play("entrando")
	elif anim_name == "entrando":
		_cargar_escena(siguiente_nivel)

func _cargar_escena(nombre: String):
	if not escenas.has(nombre):
		print("⚠ Nivel no reconocido: ", nombre)
		return

	if escena_actual != null:
		escena_actual.queue_free()
		escena_actual = null

	var nueva_escena = escenas[nombre].instantiate()
	nueva_escena.add_to_group("nivel_" + nombre)
	self.add_child(nueva_escena)
	escena_actual = nueva_escena

	await get_tree().create_timer(0.1).timeout

	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		var player = players[0]
		respawn_position = player.global_position

		var spawn = nueva_escena.get_node_or_null("SpawnPoint")
		if spawn:
			player.global_position = spawn.global_position
	else:
		print("⚠ No se encontró el jugador.")
