extends Control

@export var suyo_nombre: String = "Suyo Desconocido"
@export var suyo_descripcion: String = "Descripción por defecto."
@export var suyo_imagen_personaje: Texture2D # Para cargar la imagen desde el Inspector
@export var esta_bloqueado: bool = false # Para saber si el suyo está bloqueado

# Primero, obtenemos la referencia al nodo FondoTarjeta
@onready var fondo_tarjeta: Control = $FondoTarjeta # Asegúrate que $FondoTarjeta sea correcto (si es hijo directo)
												   # O usa %FondoTarjeta si le activaste "Nombre Único"

# Ahora, podemos usar 'fondo_tarjeta' para obtener sus hijos
@onready var lbl_titulo_suyo: Label = fondo_tarjeta.get_node("LblTituloSuyo")
@onready var lbl_descripcion: Label = fondo_tarjeta.get_node("LblDescripcion")
@onready var img_personaje: TextureRect = fondo_tarjeta.get_node("ImgPersonaje")
@onready var btn_jugar: Button = fondo_tarjeta.get_node("BtnJugar")
@onready var img_candado: TextureRect = fondo_tarjeta.get_node("ImgCandado")

# Señal que emitirá esta tarjeta cuando se presione el botón Jugar
signal suyo_seleccionado(suyo_nombre: String)

func _ready():
	# Asigna los valores de las variables exportadas a los elementos de la UI
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
