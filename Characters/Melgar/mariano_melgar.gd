extends CharacterBody2D

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var area: Area2D = $Area2D
@onready var sound: AudioStreamPlayer2D = $AudioStreamPlayer2D

var has_talked := false
var sound_timer: SceneTreeTimer = null
var player_inside := false

func _ready():
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

	if animationPlayer.has_animation("Idle"):
		animationPlayer.play("Idle")

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_inside = true

		if animationPlayer.has_animation("talk"):
			animationPlayer.play("talk")

		if not has_talked:
			has_talked = true

			if sound.stream:
				sound.play()
				sound_timer = get_tree().create_timer(2.0)
				sound_timer.timeout.connect(_stop_sound)

			var dialog_manager = get_node_or_null("/root/DialogManager")
			if dialog_manager:
				dialog_manager.show_dialogue("¡Hola! Bienvenido a la plaza.")

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
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
