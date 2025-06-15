extends Control

@onready var contenedor_carrusel = %ContenedorCarrusel # El nodo que contiene las SuyoCard
@onready var btn_flecha_izquierda = %BtnFlechaIzquierda
@onready var btn_flecha_derecha = %BtnFlechaDerecha
@onready var btn_iniciar_aventura = %BtnIniciarAventura

# Esto ya no son referencias a nodos, sino a las escenas instanciadas.
# Las tarjetas son HIJOS del contenedor_carrusel
var suyos_cards: Array[Control] = [] # Almacenará las instancias de SuyoCard
var current_card_index: int = 0 # Índice de la tarjeta actualmente visible

# Configuración de la posición de cada tarjeta
# La posición X de cada tarjeta en relación con el contenedor_carrusel
@export var card_spacing: float = 1280.0 # Espacio entre el centro de las tarjetas (ajusta según el ancho de tus tarjetas)
@export var animation_duration: float = 0.3 # Duración de la animación de deslizamiento

func _ready():
	# Inicializa el array de tarjetas instanciando la escena SuyoCard para cada suyo
	# Las imágenes y descripciones se establecerán en el Inspector de cada SuyoCard instanciada.
	_setup_suyo_cards()

	# Deshabilita el botón de iniciar aventura al principio (o según tu lógica de bloqueo)
	btn_iniciar_aventura.disabled = false # Si asumes que el primer suyo siempre está disponible

	# Conecta las señales de las flechas
	btn_flecha_izquierda.pressed.connect(_on_btn_flecha_izquierda_pressed)
	btn_flecha_derecha.pressed.connect(_on_btn_flecha_derecha_pressed)

	# Conecta la señal del botón Iniciar Aventura
	btn_iniciar_aventura.pressed.connect(_on_iniciar_aventura_pressed)

	_update_carrusel_display() # Muestra la primera tarjeta al inicio

func _setup_suyo_cards():
	# En este enfoque de carrusel, las tarjetas YA ESTÁN INSTANCIADAS
	# como hijos del ContenedorCarrusel en el editor.
	# Así que solo las recolectamos:
	for child in contenedor_carrusel.get_children():
		if child is Control and child.has_method("suyo_seleccionado"): # Verifica que sea una SuyoCard
			suyos_cards.append(child)
			# Conecta la señal 'suyo_seleccionado' de CADA tarjeta (cuando su botón JUGAR es presionado)
			child.suyo_seleccionado.connect(_on_suyo_card_selected)
			
			# Posiciona las tarjetas para el carrusel
			# Suponemos que cada tarjeta tiene un ancho similar.
			# La primera tarjeta estará en el centro (o 0), la siguiente a 'card_spacing', etc.
			child.position.x = (suyos_cards.size() - 1) * card_spacing
			child.position.y = 0 # Ajusta si necesitas desplazamiento vertical

	# Ordena las tarjetas si es necesario (ej. si las instanciaste en un orden aleatorio)
	# suyos_cards.sort_custom(func(a, b): return a.suyo_nombre < b.suyo_nombre) # Si quisieras ordenar alfabéticamente

func _on_btn_flecha_izquierda_pressed():
	if current_card_index > 0:
		current_card_index -= 1
		_animate_carrusel_to_current_card()
	_update_arrow_buttons_visibility()

func _on_btn_flecha_derecha_pressed():
	if current_card_index < suyos_cards.size() - 1:
		current_card_index += 1
		_animate_carrusel_to_current_card()
	_update_arrow_buttons_visibility()

func _animate_carrusel_to_current_card():
	var target_x = -suyos_cards[current_card_index].position.x # Mueve el contenedor para centrar la tarjeta actual
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(contenedor_carrusel, "position:x", target_x, animation_duration)
	
	_update_carrusel_display() # Actualiza el estado visual después de la animación

func _update_carrusel_display():
	# Opcional: Asegúrate de que solo la tarjeta actual sea completamente visible o se destaque.
	# En un carrusel, a menudo se mueven todas las tarjetas.
	# Este método también puede usarse para actualizar el estado del botón "Iniciar Aventura"
	# basándose en si la tarjeta actual está bloqueada.
	
	var current_card_node = suyos_cards[current_card_index]
	btn_iniciar_aventura.disabled = current_card_node.esta_bloqueado # Asumiendo que SuyoCard.gd tiene esta_bloqueado

	# Si tienes un título general arriba, podrías actualizarlo aquí:
	# lbl_titulo_general.text = "Selecciona: " + current_card_node.suyo_nombre


func _on_suyo_card_selected(suyo_name: String):
	# Esta función se llama cuando se presiona el botón JUGAR dentro de una SuyoCard.
	print("¡El jugador hizo clic en JUGAR para el suyo: ", suyo_name, " desde la tarjeta!")
	# Aquí puedes añadir una confirmación o simplemente iniciar el juego directamente.
	
	# Podrías asegurarte de que solo se inicie el juego si la tarjeta actualmente visible es la que se presionó.
	if suyo_name == suyos_cards[current_card_index].suyo_nombre:
		_start_game_for_suyo(suyo_name)
	else:
		print("Advertencia: Se presionó JUGAR en una tarjeta no activa. Esto no debería pasar en un carrusel.")


func _on_iniciar_aventura_pressed():
	# Este botón inicia el juego para la tarjeta actualmente visible
	if suyos_cards.is_empty():
		print("Error: No hay suyos para seleccionar.")
		return

	var selected_suyo_name = suyos_cards[current_card_index].suyo_nombre
	_start_game_for_suyo(selected_suyo_name)


func _start_game_for_suyo(suyo_name: String):
	print("¡Iniciando aventura en: ", suyo_name, "!")
	# Aquí la lógica para cargar la escena del juego
	if suyo_name == "Chinchaysuyo":
		get_tree().change_scene_to_file("res://Scenes/GameWorld_Chinchaysuyo.tscn")
	elif suyo_name == "Antisuyo":
		get_tree().change_scene_to_file("res://Scenes/GameWorld_Antisuyo.tscn")
	elif suyo_name == "Contisuyo":
		get_tree().change_scene_to_file("res://Scenes/GameWorld_Contisuyo.tscn")
	elif suyo_name == "Collasuyo":
		get_tree().change_scene_to_file("res://Scenes/GameWorld_Collasuyo.tscn")
	else:
		print("Error: Suyo desconocido o no mapeado para la carga de escena.")

func _update_arrow_buttons_visibility():
	btn_flecha_izquierda.disabled = (current_card_index == 0)
	btn_flecha_derecha.disabled = (current_card_index == suyos_cards.size() - 1)
