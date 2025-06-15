extends Control

@onready var chinchaysuyo_card = %ChinchaysuyoCard
@onready var antisuyo_card = %AntisuyoCard
@onready var contisuyo_card = %ContisuyoCard
@onready var collasuyo_card = %CollasuyoCard

func _ready():
	# Conecta la señal 'suyo_seleccionado' de cada tarjeta a una función en este script
	chinchaysuyo_card.suyo_seleccionado.connect(_on_suyo_card_selected)
	antisuyo_card.suyo_seleccionado.connect(_on_suyo_card_selected)
	contisuyo_card.suyo_seleccionado.connect(_on_suyo_card_selected)
	collasuyo_card.suyo_seleccionado.connect(_on_suyo_card_selected)

func _on_suyo_card_selected(suyo_nombre: String):
	print("¡El jugador seleccionó el suyo: ", suyo_nombre, " desde el panel principal!")
	# Aquí es donde pondrías la lógica para iniciar el juego,
	# cargar la escena correspondiente al suyo seleccionado.

	# Ejemplo:
	# if suyo_nombre == "Chinchaysuyo":
	#     get_tree().change_scene_to_file("res://Scenes/GameWorld_Chinchaysuyo.tscn")
	# elif suyo_nombre == "Antisuyo":
	#     get_tree().change_scene_to_file("res://Scenes/GameWorld_Antisuyo.tscn")
	# etc.
	pass # Elimina este 'pass' cuando añadas tu lógica
