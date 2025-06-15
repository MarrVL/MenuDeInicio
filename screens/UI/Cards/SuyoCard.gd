extends Control

@export var suyo_nombre: String = "Suyo Desconocido"
@export var suyo_descripcion: String = "Descripción por defecto."
@export var suyo_imagen_personaje: Texture2D # Para cargar la imagen desde el Inspector
@export var esta_bloqueado: bool = false # Para saber si el suyo está bloqueado

@onready var lbl_titulo_suyo = %LblTituloSuyo
@onready var lbl_descripcion = %LblDescripcion
@onready var img_personaje = %ImgPersonaje
@onready var btn_jugar = %BtnJugar
@onready var img_candado = %ImgCandado

# boton jugar precionado
signal suyo_seleccionado(suyo_nombre: String)

func _ready():
	# valores de variables
	lbl_titulo_suyo.text = suyo_nombre
	lbl_descripcion.text = suyo_descripcion
	if suyo_imagen_personaje:
		img_personaje.texture = suyo_imagen_personaje

	# Maneja el estado de bloqueo
	img_candado.visible = esta_bloqueado
	btn_jugar.disabled = esta_bloqueado

	# Conecta la señal del botón JUGAR
	btn_jugar.pressed.connect(_on_btn_jugar_pressed)

func _on_btn_jugar_pressed():
	# Emite la señal con el nombre del suyo para que el panel principal la capture
	emit_signal("suyo_seleccionado", suyo_nombre)
	print("Botón Jugar presionado para: ", suyo_nombre)
