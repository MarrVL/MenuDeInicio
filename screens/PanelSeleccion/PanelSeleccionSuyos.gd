extends Control

@onready var fondo_principal_ui = $FondoPrincipalUI
@onready var contenedor_carrusel = fondo_principal_ui.get_node("ContenedorCarrusel") # El nodo que contiene las SuyoCard
@onready var btn_flecha_izquierda = fondo_principal_ui.get_node("BtnFlechaIzquierda")
@onready var btn_flecha_derecha = fondo_principal_ui.get_node("BtnFlechaDerecha")
@onready var btn_jugar = fondo_principal_ui.get_node("BtnJugar")
@onready var btn_back = fondo_principal_ui.get_node("BtnBack") # Asegúrate que esta ruta es correcta para tu BtnBack

#btn_iniciar_aventura
# Esto ya no son referencias a nodos, sino a las escenas instanciadas.
# Las tarjetas son HIJOS del contenedor_carrusel
var suyos_cards: Array[Control] = [] # Almacenará las instancias de SuyoCard
var current_card_index: int = 0 # Índice de la tarjeta actualmente visible

# Configuración de la posición de cada tarjeta
# La posición X de cada tarjeta en relación con el contenedor_carrusel
@export var card_spacing: float = 1154.0 # Espacio entre el centro de las tarjetas (ajusta según el ancho de tus tarjetas)
@export var animation_duration: float = 0.3 # Duración de la animación de deslizamiento


func _ready():
	# Inicializa el array de tarjetas instanciando la escena SuyoCard para cada suyo
	# Las imágenes y descripciones se establecerán en el Inspector de cada SuyoCard instanciada.
	_setup_suyo_cards()

	# Deshabilita el botón de iniciar aventura al principio (o según tu lógica de bloqueo)
	btn_jugar.disabled = false # Si asumes que el primer suyo siempre está disponible

	# Conecta las señales de las flechas
	btn_flecha_izquierda.pressed.connect(_on_btn_flecha_izquierda_pressed)
	btn_flecha_derecha.pressed.connect(_on_btn_flecha_derecha_pressed)

	# BtonJugar
	btn_jugar.pressed.connect(_on_iniciar_aventura_pressed)

	# NUEVA CONEXIÓN: Conecta la señal del botón "Back"
	btn_back.pressed.connect(_on_btn_back_pressed) # Asegúrate que BtnBack existe en tu escena

	_update_carrusel_display() #La rimera tarjeta al inicio

func _setup_suyo_cards():
	for child in contenedor_carrusel.get_children():
		if child is Control : # Verifica que sea una SuyoCard {quite:and child.has_method("suyo_seleccionado")}
			suyos_cards.append(child)
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
	var initial_carousel_x = 580 #Donde se pocicionara la tarjeta en x
	var current_card_x_in_container = suyos_cards[current_card_index].position.x
	var target_container_x = initial_carousel_x - current_card_x_in_container
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(contenedor_carrusel, "position:x", target_container_x, animation_duration)
	
	_update_carrusel_display()

func _update_carrusel_display():
	var current_card_node = suyos_cards[current_card_index]
	btn_jugar.disabled = current_card_node.esta_bloqueado # Asumiendo que SuyoCard.gd tiene esta_bloqueado

#Codigo de antiguo botonJugar dentro de targeta
#func _on_suyo_card_selected(suyo_name: String):
	# Esta función se llama cuando se presiona el botón JUGAR dentro de una SuyoCard.
#	print("¡El jugador hizo clic en JUGAR para el suyo: ", suyo_name, " desde la tarjeta!")
	# Aquí puedes añadir una confirmación o simplemente iniciar el juego directamente.
	
	# Podrías asegurarte de que solo se inicie el juego si la tarjeta actualmente visible es la que se presionó.
#	if suyo_name == suyos_cards[current_card_index].suyo_nombre:
#		_start_game_for_suyo(suyo_name)
#	else:
#		print("Advertencia: Se presionó JUGAR en una tarjeta no activa. Esto no debería pasar en un carrusel.")


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

# NUEVA FUNCIÓN: Para el botón de regreso al menú principal
func _on_btn_back_pressed():
	print("Regresando al menú principal...")
	#deveriamos cambiar la ubicacion del menu dentro de screen algo asi res://screens/MainMenu.tscn
	get_tree().change_scene_to_file("res://screens/Menu/Menú.tscn")
