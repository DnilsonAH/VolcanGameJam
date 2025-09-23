extends CharacterBody2D

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var area: Area2D = $Area2D
@onready var sound: AudioStreamPlayer2D = $AudioStreamPlayer2D
# Referencia al nodo del globo de diálogo
@onready var dialogue_balloon = preload("res://Escenes/Dialogue/balloon.tscn")

var has_talked := false
var sound_timer: SceneTreeTimer = null
var player_inside := false

# Variables para movimiento
var is_walking := false
var walk_speed := 100.0
var world_limit_x := 10000.0  # Límite del mundo en X (ajustar según tu escena)
var start_position: Vector2

# Referencia al jugador
var main_player: Node2D = null  # Cambiado de CharacterBody2D a Node2D

func _ready():
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	if animationPlayer.has_animation("Idle"):
		animationPlayer.play("Idle")
	
	# Guardar posición inicial
	start_position = global_position
	
	# Detectar el límite del mundo automáticamente
	_detect_world_limits()
	
	# Encontrar al jugador
	call_deferred("_find_player")

func _detect_world_limits():
	# Buscar TileMap o límites en la escena
	var tilemap = get_tree().get_first_node_in_group("tilemap")
	if not tilemap:
		# Buscar por tipo de nodo
		tilemap = get_tree().get_nodes_in_group("world")[0] if get_tree().get_nodes_in_group("world").size() > 0 else null
	
	if tilemap and tilemap is TileMap:
		var used_rect = tilemap.get_used_rect()
		var tile_size = tilemap.tile_set.tile_size if tilemap.tile_set else Vector2(64, 64)
		world_limit_x = (used_rect.position.x + used_rect.size.x) * tile_size.x
		print("Límite del mundo detectado: ", world_limit_x)
	else:
		# Si no encuentra TileMap, buscar otros límites
		var camera = get_viewport().get_camera_2d()
		if camera:
			# Usar los límites de la cámara si existen
			world_limit_x = camera.limit_right if camera.limit_right > 0 else 5000.0
			print("Usando límite de cámara: ", world_limit_x)
		else:
			world_limit_x = 5000.0  # Valor por defecto
			print("Usando límite por defecto: ", world_limit_x)

func _find_player():
	main_player = get_tree().get_first_node_in_group("player")
	print("Main player encontrado: ", main_player)

func _physics_process(delta):
	# Solo moverse si está caminando (después del diálogo)
	if is_walking:
		# Mover hacia la derecha
		velocity.x = walk_speed
		velocity.y = 0  # No movimiento vertical
		
		move_and_slide()
		
		# Verificar si ha llegado al límite del mundo
		if global_position.x >= world_limit_x - 50:  # -50 para no tocar exactamente el borde
			_stop_walking()
			print("Mariano llegó al límite del mundo en X: ", global_position.x)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_inside = true
		
		# Solo mostrar animación de talk si no está caminando
		if not is_walking and animationPlayer.has_animation("talk"):
			animationPlayer.play("talk")
		
		# Solo iniciar diálogo si no ha hablado y no está caminando
		if not has_talked and not is_walking:
			has_talked = true
			
			# Reproducir sonido si existe
			if sound.stream:
				sound.play()
				sound_timer = get_tree().create_timer(2.0)
				sound_timer.timeout.connect(_stop_sound)
			
			# Iniciar el diálogo usando Dialogue Manager
			_start_dialogue()

func _start_dialogue():
	# Cargar el recurso de diálogo
	var dialogue_resource = load("res://dialogues/Dialogo_Plaza.dialogue")
	
	if dialogue_resource:
		print("Archivo de diálogo cargado correctamente")
		# Crear una instancia del globo de diálogo
		var balloon = dialogue_balloon.instantiate()
		
		# Añadir el globo a la escena
		get_tree().current_scene.add_child(balloon)
		
		# Conectar la señal de fin de diálogo
		if balloon.has_signal("dialogue_ended"):
			balloon.connect("dialogue_ended", _on_dialogue_ended)
		elif balloon.has_signal("finished"):
			balloon.connect("finished", _on_dialogue_ended)
		else:
			print("⚠️ Warning: No se encontró señal de fin de diálogo")
			# Como respaldo, iniciar movimiento después de 3 segundos
			get_tree().create_timer(3.0).timeout.connect(_on_dialogue_ended)
		
		# Iniciar el diálogo desde el punto de inicio
		balloon.start(dialogue_resource, "start")
	else:
		print("❌ ERROR: No se pudo cargar el archivo de diálogo")
		# Como respaldo, iniciar el movimiento directamente
		_on_dialogue_ended()

func _on_dialogue_ended():
	print("Diálogo terminado, Mariano comenzará a caminar")
	_start_walking()

func _start_walking():
	print("Mariano comienza a caminar hacia la derecha hasta el límite del mundo")
	is_walking = true
	
	# Cambiar a animación de caminar si existe
	if animationPlayer.has_animation("Walk_anciano"):
		animationPlayer.play("Walk_anciano")
		print("Reproduciendo animación: Walk_anciano")
	elif animationPlayer.has_animation("walk"):
		animationPlayer.play("walk")
		print("Reproduciendo animación: walk")
	elif animationPlayer.has_animation("Walk"):
		animationPlayer.play("Walk")
		print("Reproduciendo animación: Walk")
	else:
		# Si no hay animación de caminar, mantener talk
		if animationPlayer.has_animation("talk"):
			animationPlayer.play("talk")
		print("No se encontró animación de caminar, usando talk")
	
	# Notificar al jugador que debe seguir
	if main_player and main_player.has_method("follow_character"):
		main_player.follow_character(self)
	
	print("Mariano caminará desde X:", global_position.x, " hasta X:", world_limit_x)

func _stop_walking():
	print("Mariano se ha detenido")
	is_walking = false
	velocity = Vector2.ZERO
	
	# Volver a animación idle
	if animationPlayer.has_animation("Idle"):
		animationPlayer.play("Idle")

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player") and not is_walking:
		player_inside = false
		if animationPlayer.has_animation("Idle"):
			animationPlayer.play("Idle")
		
		if sound.playing:
			sound.stop()
		
		if sound_timer:
			sound_timer.timeout.disconnect(_stop_sound)
			sound_timer = null

func _stop_sound():
	if not player_inside and sound.playing:
		sound.stop()
	sound_timer = null

# Función pública para que otros scripts puedan consultar si está caminando
func is_character_walking() -> bool:
	return is_walking
