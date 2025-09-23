extends CanvasLayer

@onready var button_pause = $ButtonPause
@onready var panel_menu = $PanelMenu
@onready var btn_resume = $PanelMenu/VBoxContainer/ButtonResume
@onready var btn_menu = $PanelMenu/VBoxContainer/ButtonMenu
@onready var btn_quit = $PanelMenu/VBoxContainer/ButtonQuit


func _ready():
	# El menú de pausa siempre responde, incluso cuando el juego está pausado
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Inicialmente ocultar menú
	panel_menu.visible = false

	# Conectar señales
	button_pause.pressed.connect(_on_pause_pressed)
	btn_resume.pressed.connect(_on_resume_pressed)
	btn_menu.pressed.connect(_on_menu_pressed)
	btn_quit.pressed.connect(_on_quit_pressed)

# 👇 Detectar tecla ESC
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		if panel_menu.visible:
			_on_resume_pressed() # si ya está abierto → cerrar
		else:
			_on_pause_pressed() # si está cerrado → abrir

func _on_pause_pressed():
	panel_menu.visible = true
	get_tree().paused = true
	button_pause.visible = false

func _on_resume_pressed():
	panel_menu.visible = false
	get_tree().paused = false
	button_pause.visible = true

func _on_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/Menu/Menu.tscn")

func _on_quit_pressed():
	get_tree().quit()
